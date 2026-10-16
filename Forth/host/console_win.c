/* Public domain.
   Windowed Forth console, the editor companion pipe, and the headless agent.
   The window is the interactive program. --companion serves the editor pane.
   --agent evaluates with no window and writes the transcript to the parent. */

#include "kernel_api.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>
#include <commdlg.h>

void host_set_sink(void (*fn)(const void *, size_t));
void host_set_cls(void (*fn)(void));
void host_set_headless(int on);
void host_out(const void *p, size_t n);
void host_outs(const char *s);
void forth_set_key_hook(int (*fn)(void));
long long forth_depth(void);
int forth_eval(const char *text, size_t n);
void forth_prompt(void);
int forth_boot(void);
int forth_eval_file(const char *path);
int companion_run(const wchar_t *pipe_name);
void forth_autoload(void);
void forth_autoload_set(int on);

static int companion_name(int argc, wchar_t **argv, wchar_t *dst, int cap)
{
    int i;

    for (i = 1; i < argc; i++) {
        if (wcscmp(argv[i], L"--companion") != 0)
            continue;
        if (i + 1 < argc && argv[i + 1][0] != L'-')
            wcsncpy_s(dst, (size_t)cap, argv[i + 1], _TRUNCATE);
        else
            wcsncpy_s(dst, (size_t)cap, L"EditForthWin", _TRUNCATE);
        return 1;
    }
    return 0;
}

static int wide_to_utf8(const wchar_t *w, char *dst, int cap)
{
    int n;

    if (w == NULL || dst == NULL || cap <= 0)
        return 0;
    n = WideCharToMultiByte(CP_UTF8, 0, w, -1, dst, cap, NULL, NULL);
    if (n <= 0) {
        dst[0] = '\0';
        return 0;
    }
    return n - 1;
}

static int utf8_to_wide(const char *s, int nb, wchar_t *dst, int cap)
{
    int n;

    if (nb <= 0 || dst == NULL || cap <= 0)
        return 0;
    n = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, s, nb, dst, cap);
    if (n > 0)
        return n;
    n = MultiByteToWideChar(CP_ACP, 0, s, nb, dst, cap);
    return n > 0 ? n : 0;
}

/* Bytes at the end of a buffer that do not yet form a UTF-8 character. */
static int utf8_tail(const char *s, int n)
{
    int i;

    if (n <= 0)
        return 0;
    for (i = n - 1; i >= 0 && i >= n - 3; i--) {
        unsigned char c = (unsigned char)s[i];
        int need;
        if ((c & 0x80) == 0)
            return 0;
        if ((c & 0xC0) == 0x80)
            continue;
        if ((c & 0xE0) == 0xC0)
            need = 2;
        else if ((c & 0xF0) == 0xE0)
            need = 3;
        else if ((c & 0xF8) == 0xF0)
            need = 4;
        else
            return 0;
        if (n - i < need)
            return n - i;
        return 0;
    }
    return 0;
}

/* --------------------------------------------------------------------- */
/* Agent                                                                  */
/* --------------------------------------------------------------------- */

static HANDLE agent_out;
static HANDLE agent_in;
static HANDLE g_tee = INVALID_HANDLE_VALUE;

static void agent_write_tee(const void *p, size_t n);

static void agent_bind_stdio(void)
{
    HANDLE out = GetStdHandle(STD_OUTPUT_HANDLE);
    DWORD kind;

    kind = (out == NULL || out == INVALID_HANDLE_VALUE) ? FILE_TYPE_UNKNOWN : GetFileType(out);
    if (out == NULL || out == INVALID_HANDLE_VALUE || kind == FILE_TYPE_UNKNOWN) {
        if (AttachConsole(ATTACH_PARENT_PROCESS))
            out = GetStdHandle(STD_OUTPUT_HANDLE);
    }
    agent_out = out;
    agent_in = GetStdHandle(STD_INPUT_HANDLE);
}

static void agent_write(const void *p, size_t n)
{
    const char *s = (const char *)p;
    DWORD wrote;

    if (agent_out == NULL || agent_out == INVALID_HANDLE_VALUE)
        return;
    while (n > 0) {
        if (!WriteFile(agent_out, s, (DWORD)n, &wrote, NULL) || wrote == 0)
            return;
        s += wrote;
        n -= wrote;
    }
}

static int agent_read_byte(void)
{
    char c;
    DWORD n = 0;

    if (agent_in == NULL || agent_in == INVALID_HANDLE_VALUE)
        return -1;
    if (!ReadFile(agent_in, &c, 1, &n, NULL) || n == 0)
        return -1;
    if (c == '\r')
        return agent_read_byte();
    return (unsigned char)c;
}

static int agent_env(const wchar_t *name)
{
    wchar_t buf[4];
    DWORD n = GetEnvironmentVariableW(name, buf, 4);
    return n == 1 && buf[0] == L'1';
}

static int agent_requested(int argc, wchar_t **argv)
{
    int i;

    if (agent_env(L"FORTH64_AGENT") || agent_env(L"EDITFORTH_AGENT"))
        return 1;
    for (i = 1; i < argc; i++) {
        if (wcscmp(argv[i], L"--agent") == 0 || wcscmp(argv[i], L"-agent") == 0)
            return 1;
    }
    return 0;
}

static void agent_help(void)
{
    static const char help[] =
        "EditForthWin agent channel — headless load / eval / capture\r\n"
        "\r\n"
        "EditForthWin --agent [options]\r\n"
        "\r\n"
        "Options:\r\n"
        "  -e, --eval <line>       Evaluate a Forth line\r\n"
        "  -f, --file <path>       Evaluate a file (also --fload / --include)\r\n"
        "  -c, --cwd <path>        Change directory before work\r\n"
        "  -o, --out <path>        Write the transcript to path (stdout always)\r\n"
        "  --repl                  Read further lines from stdin until EOF or BYE\r\n"
        "  --no-autoload           Skip Documents\\EditForthWin\\AutoLoad\\autoload.fth\r\n"
        "  -h, --help              This help\r\n"
        "\r\n"
        "Environment:\r\n"
        "  FORTH64_AGENT=1         Same as --agent\r\n"
        "  EDITFORTH_AGENT=1       Same as --agent\r\n"
        "\r\n"
        "Examples:\r\n"
        "  fortharm64.exe --agent -e \"2 3 + .\"\r\n"
        "  forthx64.exe --agent -e \"2 3 + .\"\r\n"
        "  fortharm64.exe --agent -f smoke.fth -o out.txt\r\n"
        "  fortharm64.exe --agent --repl\r\n"
        "\r\n"
        "Exit 0 means every step returned 0. Exit 1 means a step failed.\r\n";
    host_out(help, sizeof help - 1);
}

static int agent_is_bye(const char *s)
{
    while (*s == ' ' || *s == '\t')
        s++;
    if ((s[0] == 'B' || s[0] == 'b') &&
        (s[1] == 'Y' || s[1] == 'y') &&
        (s[2] == 'E' || s[2] == 'e')) {
        s += 3;
        while (*s == ' ' || *s == '\t')
            s++;
        return *s == '\0';
    }
    return 0;
}

static int agent_read_line(char *dst, int cap)
{
    int n = 0;

    if (cap <= 1)
        return -1;
    for (;;) {
        int c = agent_read_byte();
        if (c < 0)
            return n == 0 ? -1 : n;
        if (c == '\n')
            break;
        if (n + 1 < cap)
            dst[n++] = (char)c;
    }
    dst[n] = '\0';
    return n;
}

static int agent_run(int argc, wchar_t **argv)
{
    host_set_headless(1);
    enum { STEP_EVAL, STEP_FILE };
    struct step {
        int kind;
        char text[2048];
    } steps[64];
    int nsteps = 0;
    int help = 0;
    int repl = 0;
    int failed = 0;
    int i;
    wchar_t cwd[MAX_PATH];
    wchar_t out_path[MAX_PATH];
    int have_cwd = 0;
    int have_out = 0;

    cwd[0] = 0;
    out_path[0] = 0;
    agent_bind_stdio();
    host_set_sink(agent_write_tee);
    forth_set_key_hook(agent_read_byte);

    for (i = 1; i < argc; i++) {
        wchar_t *a = argv[i];
        if (wcscmp(a, L"--agent") == 0 || wcscmp(a, L"-agent") == 0)
            continue;
        if (wcscmp(a, L"-h") == 0 || wcscmp(a, L"--help") == 0 || wcscmp(a, L"-help") == 0) {
            help = 1;
            continue;
        }
        if (wcscmp(a, L"--repl") == 0) {
            repl = 1;
            continue;
        }
        if (wcscmp(a, L"--autoload") == 0)
            continue;
        if (wcscmp(a, L"--no-autoload") == 0) {
            forth_autoload_set(0);
            continue;
        }
        if (wcscmp(a, L"-e") == 0 || wcscmp(a, L"--eval") == 0 ||
            wcscmp(a, L"-f") == 0 || wcscmp(a, L"--file") == 0 ||
            wcscmp(a, L"--fload") == 0 || wcscmp(a, L"--include") == 0 ||
            wcscmp(a, L"-c") == 0 || wcscmp(a, L"--cwd") == 0 ||
            wcscmp(a, L"-o") == 0 || wcscmp(a, L"--out") == 0 ||
            wcscmp(a, L"--transcript") == 0) {
            int is_eval = (wcscmp(a, L"-e") == 0 || wcscmp(a, L"--eval") == 0);
            int is_file = (wcscmp(a, L"-f") == 0 || wcscmp(a, L"--file") == 0 ||
                           wcscmp(a, L"--fload") == 0 || wcscmp(a, L"--include") == 0);
            int is_cwd = (wcscmp(a, L"-c") == 0 || wcscmp(a, L"--cwd") == 0);
            if (i + 1 >= argc) {
                help = 1;
                break;
            }
            i++;
            if (is_cwd) {
                wcsncpy_s(cwd, MAX_PATH, argv[i], _TRUNCATE);
                have_cwd = 1;
            } else if (!is_eval && !is_file) {
                wcsncpy_s(out_path, MAX_PATH, argv[i], _TRUNCATE);
                have_out = 1;
                if (g_tee != INVALID_HANDLE_VALUE)
                    CloseHandle(g_tee);
                g_tee = CreateFileW(out_path, GENERIC_WRITE, FILE_SHARE_READ, NULL,
                                    CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
                if (g_tee == INVALID_HANDLE_VALUE) {
                    host_outs("[EditForthWin agent] ERROR: cannot write transcript\n");
                    return 1;
                }
            } else if (nsteps < 64) {
                steps[nsteps].kind = is_eval ? STEP_EVAL : STEP_FILE;
                wide_to_utf8(argv[i], steps[nsteps].text, (int)sizeof steps[nsteps].text);
                nsteps++;
            }
            continue;
        }
        if (a[0] == L'-') {
            char msg[256];
            char opt[128];
            wide_to_utf8(a, opt, (int)sizeof opt);
            snprintf(msg, sizeof msg, "[EditForthWin agent] unknown option: %s\n", opt);
            host_outs(msg);
        }
    }

    if (help) {
        agent_help();
        if (g_tee != INVALID_HANDLE_VALUE)
            CloseHandle(g_tee);
        return 0;
    }

    host_outs("[EditForthWin agent] start\n");
    if (forth_boot() != 0) {
        host_outs("[EditForthWin agent] FATAL: kernel_init failed\n");
        failed = 1;
        goto done;
    }
    forth_autoload();

    if (have_cwd) {
        char msg[MAX_PATH * 3 + 64];
        char path[MAX_PATH * 3];
        wide_to_utf8(cwd, path, (int)sizeof path);
        if (SetCurrentDirectoryW(cwd)) {
            snprintf(msg, sizeof msg, "[EditForthWin agent] cwd %s\n", path);
            host_outs(msg);
        } else {
            snprintf(msg, sizeof msg, "[EditForthWin agent] ERROR: cannot chdir %s\n", path);
            host_outs(msg);
            failed = 1;
            goto done;
        }
    }

    for (i = 0; i < nsteps; i++) {
        char msg[2200];
        int st;
        if (steps[i].kind == STEP_EVAL) {
            snprintf(msg, sizeof msg, "[EditForthWin agent] eval: %s\n", steps[i].text);
            host_outs(msg);
            st = forth_eval(steps[i].text, strlen(steps[i].text));
        } else {
            snprintf(msg, sizeof msg, "[EditForthWin agent] load: %s\n", steps[i].text);
            host_outs(msg);
            st = forth_eval_file(steps[i].text);
        }
        snprintf(msg, sizeof msg, "[EditForthWin agent] status=%d depth=%lld\n", st, forth_depth());
        host_outs(msg);
        if (st != 0)
            failed = 1;
    }

    if (repl) {
        char line[2048];
        host_outs("[EditForthWin agent] repl (stdin) — EOF to finish\n");
        forth_prompt();
        while (agent_read_line(line, (int)sizeof line) >= 0) {
            if (line[0] == '\0')
                continue;
            if (agent_is_bye(line)) {
                host_outs("[EditForthWin agent] BYE\n");
                break;
            }
            if (forth_eval(line, strlen(line)) != 0)
                failed = 1;
            forth_prompt();
        }
        host_outs("\n");
    }

    if (nsteps == 0 && !repl) {
        host_outs("[EditForthWin agent] nothing to do (use -e, -f, or --repl)\n");
        host_outs("Try: fortharm64.exe --agent --help\n");
        failed = 1;
    }

    host_outs(failed ? "[EditForthWin agent] DONE (failed)\n"
                     : "[EditForthWin agent] DONE (ok)\n");

done:
    if (g_tee != INVALID_HANDLE_VALUE) {
        CloseHandle(g_tee);
        g_tee = INVALID_HANDLE_VALUE;
    }
    (void)have_out;
    return failed ? 1 : 0;
}

/* --------------------------------------------------------------------- */
/* Window                                                                 */
/* --------------------------------------------------------------------- */

#define WM_APP_TEXT (WM_APP + 1)
#define WM_APP_READY (WM_APP + 2)
#define WM_APP_CLS (WM_APP + 3)
#define WM_APP_INCLUDE (WM_APP + 4)

static HWND g_hwnd;
static HANDLE g_pick_ev;
static char g_pick_path[1024];
static long g_pick_len;

/* Bare INCLUDE / FLOAD. No console window (agent or companion) returns 0
   and does not open a dialog. The window thread runs the picker. */
long long host_include_dialog(void **out_ptr)
{
    if (out_ptr != NULL)
        *out_ptr = NULL;
    if (g_hwnd == NULL || g_pick_ev == NULL)
        return 0;
    g_pick_len = 0;
    g_pick_path[0] = '\0';
    ResetEvent(g_pick_ev);
    if (!PostMessageW(g_hwnd, WM_APP_INCLUDE, 0, 0))
        return 0;
    if (WaitForSingleObject(g_pick_ev, 120000) != WAIT_OBJECT_0)
        return 0;
    if (g_pick_len <= 0)
        return 0;
    if (out_ptr != NULL)
        *out_ptr = g_pick_path;
    return g_pick_len;
}

static void include_dialog_now(void)
{
    wchar_t file[1024];
    OPENFILENAMEW ofn;
    int n;

    file[0] = 0;
    memset(&ofn, 0, sizeof ofn);
    ofn.lStructSize = sizeof ofn;
    ofn.hwndOwner = g_hwnd;
    ofn.lpstrFile = file;
    ofn.nMaxFile = 1024;
    ofn.lpstrFilter = L"Forth files\0*.fth;*.fs;*.4th;*.f;*.txt\0All files\0*.*\0";
    ofn.nFilterIndex = 1;
    ofn.lpstrTitle = L"Include";
    ofn.Flags = OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | OFN_NOCHANGEDIR | OFN_EXPLORER;
    if (!GetOpenFileNameW(&ofn)) {
        g_pick_len = 0;
        SetEvent(g_pick_ev);
        return;
    }
    n = WideCharToMultiByte(CP_UTF8, 0, file, -1, g_pick_path, (int)sizeof g_pick_path, NULL, NULL);
    if (n <= 1) {
        g_pick_len = 0;
        g_pick_path[0] = '\0';
        SetEvent(g_pick_ev);
        return;
    }
    g_pick_len = n - 1;
    SetEvent(g_pick_ev);
}
static HFONT g_font;
static CRITICAL_SECTION g_text_cs;
static CRITICAL_SECTION g_key_cs;
static CRITICAL_SECTION g_line_cs;
static HANDLE g_key_ev;
static HANDLE g_line_ev;
static volatile LONG g_key_waiting;
static int g_key_value;
static volatile LONG g_busy;
static volatile LONG g_quit;

struct text_chunk {
    struct text_chunk *next;
    int n;
    char data[4096];
};

static struct text_chunk *g_text_head;
static struct text_chunk *g_text_tail;
static char g_utf_hold[8];
static int g_utf_hold_n;

static wchar_t *g_prot;
static int g_prot_n;
static int g_prot_cap;
static int g_doc_n;
static int g_line_h = 18;
static int g_char_w = 8;
static int g_scroll;
static int g_stick = 1;

#define HIST_MAX 200
static char g_hist[HIST_MAX][1024];
static int g_hist_n;
static int g_hist_pos;

static char g_line[4096];
static size_t g_line_n;

static void gui_write(const void *p, size_t n)
{
    const char *s = (const char *)p;
    int post = 0;

    if (n == 0 || g_hwnd == NULL)
        return;
    EnterCriticalSection(&g_text_cs);
    post = (g_text_head == NULL);
    while (n > 0) {
        int room;
        int take;
        if (g_text_tail == NULL || g_text_tail->n == (int)sizeof g_text_tail->data) {
            struct text_chunk *c = (struct text_chunk *)malloc(sizeof *c);
            if (c == NULL)
                break;
            c->next = NULL;
            c->n = 0;
            if (g_text_tail != NULL)
                g_text_tail->next = c;
            else
                g_text_head = c;
            g_text_tail = c;
        }
        room = (int)sizeof g_text_tail->data - g_text_tail->n;
        take = (int)n < room ? (int)n : room;
        memcpy(g_text_tail->data + g_text_tail->n, s, (size_t)take);
        g_text_tail->n += take;
        s += take;
        n -= (size_t)take;
    }
    LeaveCriticalSection(&g_text_cs);
    if (post)
        PostMessageW(g_hwnd, WM_APP_TEXT, 0, 0);
}

static void gui_cls(void)
{
    struct text_chunk *c;
    struct text_chunk *n;

    if (g_hwnd == NULL)
        return;
    EnterCriticalSection(&g_text_cs);
    c = g_text_head;
    g_text_head = NULL;
    g_text_tail = NULL;
    LeaveCriticalSection(&g_text_cs);
    while (c != NULL) {
        n = c->next;
        free(c);
        c = n;
    }
    PostMessageW(g_hwnd, WM_APP_CLS, 0, 0);
}

static int gui_key(void)
{
    EnterCriticalSection(&g_key_cs);
    g_key_waiting = 1;
    g_key_value = -1;
    LeaveCriticalSection(&g_key_cs);
    WaitForSingleObject(g_key_ev, INFINITE);
    return g_key_value;
}

static void gui_offer_key(int c)
{
    int took = 0;

    EnterCriticalSection(&g_key_cs);
    if (g_key_waiting) {
        g_key_value = c;
        g_key_waiting = 0;
        took = 1;
    }
    LeaveCriticalSection(&g_key_cs);
    if (took) {
        unsigned char b = (unsigned char)c;
        SetEvent(g_key_ev);
        if (c >= 0)
            gui_write(&b, 1);
    }
}

static void console_refresh(void)
{
    if (g_hwnd != NULL)
        InvalidateRect(g_hwnd, NULL, FALSE);
}

static void doc_grow(int need)
{
    int cap;
    wchar_t *grown;

    if (need + 1 <= g_prot_cap)
        return;
    cap = g_prot_cap > 0 ? g_prot_cap : 4096;
    while (cap < need + 1)
        cap *= 2;
    grown = (wchar_t *)realloc(g_prot, (size_t)cap * sizeof(wchar_t));
    if (grown == NULL)
        return;
    g_prot = grown;
    g_prot_cap = cap;
}

static void doc_splice(int at, int delete_n, const wchar_t *ws, int add_n)
{
    int tail;

    if (g_prot == NULL && g_prot_cap == 0)
        doc_grow(add_n > 0 ? add_n : 1);
    if (g_prot == NULL)
        return;
    if (at < 0)
        at = 0;
    if (at > g_doc_n)
        at = g_doc_n;
    if (delete_n < 0)
        delete_n = 0;
    if (at + delete_n > g_doc_n)
        delete_n = g_doc_n - at;
    doc_grow(g_doc_n - delete_n + add_n);
    if (g_prot == NULL)
        return;
    tail = g_doc_n - (at + delete_n);
    if (tail > 0 && add_n != delete_n)
        memmove(g_prot + at + add_n, g_prot + at + delete_n,
                (size_t)tail * sizeof(wchar_t));
    if (add_n > 0 && ws != NULL)
        memcpy(g_prot + at, ws, (size_t)add_n * sizeof(wchar_t));
    g_doc_n = g_doc_n - delete_n + add_n;
    g_prot[g_doc_n] = 0;
}

static void doc_output(const wchar_t *ws, int n)
{
    wchar_t *tmp;
    int i;
    int m = 0;

    if (n <= 0)
        return;
    tmp = (wchar_t *)malloc((size_t)n * sizeof(wchar_t));
    if (tmp == NULL)
        return;
    for (i = 0; i < n; i++) {
        if (ws[i] != L'\r')
            tmp[m++] = ws[i];
    }
    doc_splice(g_prot_n, 0, tmp, m);
    g_prot_n += m;
    free(tmp);
    g_stick = 1;
    console_refresh();
}

static void console_backspace(void)
{
    if (g_key_waiting || g_doc_n <= g_prot_n)
        return;
    doc_splice(g_doc_n - 1, 1, NULL, 0);
    console_refresh();
}

static void console_type(wchar_t ch)
{
    if (g_key_waiting) {
        gui_offer_key((int)ch);
        return;
    }
    if (ch < 32)
        return;
    doc_splice(g_doc_n, 0, &ch, 1);
    g_stick = 1;
    console_refresh();
}

static void console_submit(void)
{
    char utf8[4096];
    wchar_t nl[2];
    int in_n;
    int nb;

    if (g_key_waiting) {
        gui_offer_key('\n');
        return;
    }
    if (g_busy)
        return;
    in_n = g_doc_n - g_prot_n;
    if (in_n < 0)
        in_n = 0;
    if (in_n >= 2048)
        in_n = 2047;
    nb = 0;
    if (in_n > 0 && g_prot != NULL)
        nb = wide_to_utf8(g_prot + g_prot_n, utf8, (int)sizeof utf8);
    while (nb > 0 && (utf8[nb - 1] == '\n' || utf8[nb - 1] == '\r'))
        utf8[--nb] = '\0';
    nl[0] = L'\n';
    doc_splice(g_doc_n, 0, nl, 1);
    g_prot_n = g_doc_n;
    if (nb > 0 && g_hist_n < HIST_MAX) {
        strncpy_s(g_hist[g_hist_n], sizeof g_hist[0], utf8, _TRUNCATE);
        g_hist_n++;
    }
    g_hist_pos = g_hist_n;
    EnterCriticalSection(&g_line_cs);
    if ((size_t)nb >= sizeof g_line)
        nb = (int)sizeof g_line - 1;
    memcpy(g_line, utf8, (size_t)nb);
    g_line[nb] = '\0';
    g_line_n = (size_t)nb;
    g_busy = 1;
    LeaveCriticalSection(&g_line_cs);
    g_stick = 1;
    console_refresh();
    SetEvent(g_line_ev);
}

static void console_history(int up)
{
    wchar_t wide[1024];
    int n;
    const char *line;

    if (g_busy || g_key_waiting || g_hist_n == 0)
        return;
    if (up) {
        if (g_hist_pos <= 0)
            return;
        g_hist_pos--;
    } else if (g_hist_pos >= g_hist_n) {
        doc_splice(g_prot_n, g_doc_n - g_prot_n, L"", 0);
        console_refresh();
        return;
    } else {
        g_hist_pos++;
        if (g_hist_pos >= g_hist_n) {
            doc_splice(g_prot_n, g_doc_n - g_prot_n, L"", 0);
            console_refresh();
            return;
        }
    }
    line = g_hist[g_hist_pos];
    n = utf8_to_wide(line, (int)strlen(line), wide, 1023);
    wide[n] = 0;
    doc_splice(g_prot_n, g_doc_n - g_prot_n, wide, n);
    console_refresh();
}

static void console_drain(void)
{
    struct text_chunk *list;
    char *bytes;
    int nbytes;
    int tail;
    wchar_t *wide;
    int wn;

    EnterCriticalSection(&g_text_cs);
    list = g_text_head;
    g_text_head = NULL;
    g_text_tail = NULL;
    LeaveCriticalSection(&g_text_cs);
    if (list == NULL && g_utf_hold_n == 0)
        return;

    nbytes = g_utf_hold_n;
    for (struct text_chunk *c = list; c != NULL; c = c->next)
        nbytes += c->n;
    bytes = (char *)malloc((size_t)nbytes + 1);
    if (bytes == NULL) {
        while (list != NULL) {
            struct text_chunk *next = list->next;
            free(list);
            list = next;
        }
        return;
    }
    if (g_utf_hold_n > 0)
        memcpy(bytes, g_utf_hold, (size_t)g_utf_hold_n);
    nbytes = g_utf_hold_n;
    while (list != NULL) {
        struct text_chunk *next = list->next;
        memcpy(bytes + nbytes, list->data, (size_t)list->n);
        nbytes += list->n;
        free(list);
        list = next;
    }
    tail = utf8_tail(bytes, nbytes);
    if (tail > (int)sizeof g_utf_hold)
        tail = 0;
    g_utf_hold_n = tail;
    if (tail > 0)
        memcpy(g_utf_hold, bytes + nbytes - tail, (size_t)tail);
    nbytes -= tail;
    if (nbytes > 0) {
        wide = (wchar_t *)malloc((size_t)(nbytes + 1) * sizeof(wchar_t));
        if (wide != NULL) {
            wn = utf8_to_wide(bytes, nbytes, wide, nbytes + 1);
            doc_output(wide, wn);
            free(wide);
        }
    }
    free(bytes);
}

static int console_lines(int width, int **starts)
{
    int cols;
    int count = 1;
    int i = 0;
    int *at;

    cols = width / (g_char_w > 0 ? g_char_w : 8);
    if (cols < 1)
        cols = 1;
    at = (int *)malloc(sizeof(int) * (size_t)(g_doc_n + 2));
    if (at == NULL)
        return 0;
    at[0] = 0;
    while (i < g_doc_n && g_prot != NULL) {
        int col = 0;
        while (i < g_doc_n && g_prot[i] != L'\n' && col < cols) {
            i++;
            col++;
        }
        if (i < g_doc_n && g_prot[i] == L'\n')
            i++;
        if (i < g_doc_n)
            at[count++] = i;
        else
            break;
    }
    *starts = at;
    return count;
}

static void console_paint(HWND hwnd)
{
    PAINTSTRUCT ps;
    HDC dc;
    RECT rc;
    HFONT old;
    int *starts = NULL;
    int nlines;
    int visible;
    int y;
    int i;
    TEXTMETRICW tm;

    dc = BeginPaint(hwnd, &ps);
    GetClientRect(hwnd, &rc);
    if (g_font != NULL)
        old = (HFONT)SelectObject(dc, g_font);
    else
        old = NULL;
    GetTextMetricsW(dc, &tm);
    g_line_h = tm.tmHeight > 0 ? tm.tmHeight : 18;
    g_char_w = tm.tmAveCharWidth > 0 ? tm.tmAveCharWidth : 8;
    SetBkColor(dc, GetSysColor(COLOR_WINDOW));
    SetTextColor(dc, GetSysColor(COLOR_WINDOWTEXT));
    FillRect(dc, &rc, (HBRUSH)(COLOR_WINDOW + 1));
    nlines = console_lines(rc.right > 8 ? rc.right - 8 : 1, &starts);
    visible = g_line_h > 0 ? rc.bottom / g_line_h : 1;
    if (visible < 1)
        visible = 1;
    if (g_stick)
        g_scroll = nlines > visible ? nlines - visible : 0;
    if (g_scroll < 0)
        g_scroll = 0;
    if (g_scroll > nlines - 1 && nlines > 0)
        g_scroll = nlines - 1;
    {
        SCROLLINFO si;
        si.cbSize = sizeof si;
        si.fMask = SIF_RANGE | SIF_PAGE | SIF_POS;
        si.nMin = 0;
        si.nMax = nlines > 0 ? nlines - 1 : 0;
        si.nPage = (UINT)visible;
        si.nPos = g_scroll;
        SetScrollInfo(hwnd, SB_VERT, &si, TRUE);
    }
    y = 0;
    for (i = g_scroll; i < nlines && y < rc.bottom; i++) {
        int from = starts[i];
        int to = (i + 1 < nlines) ? starts[i + 1] : g_doc_n;
        int len = to - from;
        if (len > 0 && g_prot != NULL && g_prot[from + len - 1] == L'\n')
            len--;
        if (len < 0)
            len = 0;
        if (len > 0)
            TextOutW(dc, 4, y, g_prot + from, len);
        y += g_line_h;
    }
    if (GetFocus() == hwnd && starts != NULL) {
        int caret_line = nlines > 0 ? nlines - 1 : 0;
        int caret_col = 0;
        int pos = g_doc_n;
        int k;
        for (k = 0; k < nlines; k++) {
            int next = (k + 1 < nlines) ? starts[k + 1] : g_doc_n + 1;
            if (pos < next || k == nlines - 1) {
                caret_line = k;
                caret_col = pos - starts[k];
                if (caret_col > 0 && g_prot != NULL &&
                    starts[k] + caret_col <= g_doc_n &&
                    g_prot[starts[k] + caret_col - 1] == L'\n')
                    caret_col--;
                break;
            }
        }
        SetCaretPos(4 + caret_col * g_char_w, (caret_line - g_scroll) * g_line_h);
    }
    if (old != NULL)
        SelectObject(dc, old);
    free(starts);
    EndPaint(hwnd, &ps);
}

static int g_return_from_key;

static void console_on_return(int from_key)
{
    if (from_key) {
        g_return_from_key = 1;
        console_submit();
        return;
    }
    if (g_return_from_key) {
        g_return_from_key = 0;
        return;
    }
    console_submit();
}

static DWORD WINAPI forth_thread(LPVOID arg)
{
    int argc = 0;
    wchar_t **argv = (wchar_t **)arg;
    int i;

    while (argv != NULL && argv[argc] != NULL)
        argc++;
    if (forth_boot() != 0) {
        PostMessageW(g_hwnd, WM_CLOSE, 0, 0);
        return 1;
    }
    forth_autoload();
    for (i = 1; i < argc; i++) {
        char path[MAX_PATH * 3];
        if (argv[i][0] == L'-')
            continue;
        wide_to_utf8(argv[i], path, (int)sizeof path);
        if (forth_eval_file(path) != 0)
            break;
    }
    forth_prompt();
    InterlockedExchange(&g_busy, 0);
    PostMessageW(g_hwnd, WM_APP_READY, 0, 0);
    for (;;) {
        char line[4096];
        size_t n;
        int rc;
        WaitForSingleObject(g_line_ev, INFINITE);
        if (g_quit)
            break;
        EnterCriticalSection(&g_line_cs);
        n = g_line_n;
        if (n >= sizeof line)
            n = sizeof line - 1;
        memcpy(line, g_line, n);
        line[n] = '\0';
        LeaveCriticalSection(&g_line_cs);
        rc = forth_eval(line, n);
        if (rc != 0 && agent_is_bye(line)) {
            PostMessageW(g_hwnd, WM_CLOSE, 0, 0);
            break;
        }
        forth_prompt();
        InterlockedExchange(&g_busy, 0);
    }
    return 0;
}

static LRESULT CALLBACK wnd_proc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp)
{
    switch (msg) {
    case WM_PAINT:
        console_paint(hwnd);
        return 0;
    case WM_SIZE:
        console_refresh();
        return 0;
    case WM_ERASEBKGND:
        return 1;
    case WM_SETFOCUS:
        CreateCaret(hwnd, NULL, 2, g_line_h);
        ShowCaret(hwnd);
        console_refresh();
        return 0;
    case WM_KILLFOCUS:
        HideCaret(hwnd);
        DestroyCaret();
        return 0;
    case WM_KEYDOWN:
        if (wp == VK_RETURN) {
            console_on_return(1);
            return 0;
        }
        if (wp == VK_BACK) {
            console_backspace();
            return 0;
        }
        if (wp == VK_UP) {
            console_history(1);
            return 0;
        }
        if (wp == VK_DOWN) {
            console_history(0);
            return 0;
        }
        break;
    case WM_CHAR:
        if (wp == '\r' || wp == '\n') {
            console_on_return(0);
            return 0;
        }
        if (wp == 8) {
            console_backspace();
            return 0;
        }
        console_type((wchar_t)wp);
        return 0;
    case WM_VSCROLL: {
        int code = LOWORD(wp);
        if (code == SB_LINEUP)
            g_scroll--;
        else if (code == SB_LINEDOWN)
            g_scroll++;
        else if (code == SB_PAGEUP)
            g_scroll -= 12;
        else if (code == SB_PAGEDOWN)
            g_scroll += 12;
        else if (code == SB_THUMBTRACK || code == SB_THUMBPOSITION)
            g_scroll = HIWORD(wp);
        if (g_scroll < 0)
            g_scroll = 0;
        g_stick = 0;
        console_refresh();
        return 0;
    }
    case WM_MOUSEWHEEL:
        g_scroll -= GET_WHEEL_DELTA_WPARAM(wp) / WHEEL_DELTA;
        if (g_scroll < 0)
            g_scroll = 0;
        g_stick = 0;
        console_refresh();
        return 0;
    case WM_GETTEXTLENGTH:
        return g_doc_n;
    case WM_GETTEXT: {
        int cap = (int)wp;
        wchar_t *dst = (wchar_t *)lp;
        int n = g_doc_n;
        if (dst == NULL || cap <= 0)
            return 0;
        if (n >= cap)
            n = cap - 1;
        if (n > 0 && g_prot != NULL)
            memcpy(dst, g_prot, (size_t)n * sizeof(wchar_t));
        dst[n] = 0;
        return n;
    }
    case WM_APP_TEXT:
        console_drain();
        return 0;
    case WM_APP_CLS:
        g_doc_n = 0;
        g_prot_n = 0;
        if (g_prot != NULL)
            g_prot[0] = 0;
        InvalidateRect(hwnd, NULL, TRUE);
        return 0;
    case WM_APP_INCLUDE:
        include_dialog_now();
        return 0;
    case WM_APP_READY:
        SetForegroundWindow(hwnd);
        SetFocus(hwnd);
        return 0;
    case WM_GETMINMAXINFO: {
        MINMAXINFO *mm = (MINMAXINFO *)lp;
        mm->ptMinTrackSize.x = 640;
        mm->ptMinTrackSize.y = 400;
        return 0;
    }
    case WM_DESTROY:
        g_quit = 1;
        SetEvent(g_line_ev);
        SetEvent(g_key_ev);
        if (g_pick_ev != NULL)
            SetEvent(g_pick_ev);
        PostQuitMessage(0);
        return 0;
    default:
        return DefWindowProcW(hwnd, msg, wp, lp);
    }
    return DefWindowProcW(hwnd, msg, wp, lp);
}

static int window_run(wchar_t **argv, int show)
{
    WNDCLASSW wc;
    RECT rc;
    int dpi;
    MSG msg;
    HANDLE thread;

    InitializeCriticalSection(&g_text_cs);
    InitializeCriticalSection(&g_key_cs);
    InitializeCriticalSection(&g_line_cs);
    g_key_ev = CreateEventW(NULL, FALSE, FALSE, NULL);
    g_line_ev = CreateEventW(NULL, FALSE, FALSE, NULL);
    g_pick_ev = CreateEventW(NULL, FALSE, FALSE, NULL);
    g_busy = 1;

    memset(&wc, 0, sizeof wc);
    wc.lpfnWndProc = wnd_proc;
    wc.hInstance = GetModuleHandleW(NULL);
    wc.hCursor = LoadCursor(NULL, IDC_IBEAM);
    wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wc.lpszClassName = L"EditForthWinConsole";
    wc.style = CS_HREDRAW | CS_VREDRAW;
    RegisterClassW(&wc);

    rc.left = 0;
    rc.top = 0;
    rc.right = 900;
    rc.bottom = 560;
    dpi = GetDpiForSystem();
    rc.right = MulDiv(rc.right, dpi, 96);
    rc.bottom = MulDiv(rc.bottom, dpi, 96);
    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW | WS_VSCROLL, FALSE);
    {
        wchar_t title[128];
        title[0] = L'\0';
        if (MultiByteToWideChar(CP_UTF8, 0, kernel_console, -1, title, 128) <= 0)
            wcsncpy_s(title, 128, L"EditForthWin", _TRUNCATE);
        g_hwnd = CreateWindowExW(0, L"EditForthWinConsole", title,
                              WS_OVERLAPPEDWINDOW | WS_VSCROLL | WS_CLIPCHILDREN,
                              CW_USEDEFAULT, CW_USEDEFAULT,
                              rc.right - rc.left, rc.bottom - rc.top,
                              NULL, NULL, wc.hInstance, NULL);
    }
    g_font = CreateFontW(-MulDiv(13, dpi, 72), 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE,
                          DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
                          CLEARTYPE_QUALITY, FIXED_PITCH | FF_MODERN, L"Consolas");
    ShowWindow(g_hwnd, show);
    UpdateWindow(g_hwnd);
    SetFocus(g_hwnd);

    host_set_sink(gui_write);
    host_set_cls(gui_cls);
    forth_set_key_hook(gui_key);
    thread = CreateThread(NULL, 0, forth_thread, argv, 0, NULL);

    while (GetMessageW(&msg, NULL, 0, 0) > 0) {
        TranslateMessage(&msg);
        DispatchMessageW(&msg);
    }
    g_quit = 1;
    SetEvent(g_line_ev);
    SetEvent(g_key_ev);
    if (thread != NULL) {
        WaitForSingleObject(thread, 2000);
        CloseHandle(thread);
    }
    if (g_font != NULL)
        DeleteObject(g_font);
    return (int)msg.wParam;
}

static void agent_write_tee(const void *p, size_t n)
{
    DWORD wrote;
    agent_write(p, n);
    if (g_tee == NULL || g_tee == INVALID_HANDLE_VALUE)
        return;
    while (n > 0) {
        if (!WriteFile(g_tee, p, (DWORD)n, &wrote, NULL) || wrote == 0)
            return;
        p = (const char *)p + wrote;
        n -= wrote;
    }
}

int WINAPI WinMain(HINSTANCE inst, HINSTANCE prev, LPSTR cmd, int show)
{
    int argc = 0;
    wchar_t **argv;
    int rc;

    (void)inst;
    (void)prev;
    (void)cmd;
    argv = CommandLineToArgvW(GetCommandLineW(), &argc);
    if (argv == NULL)
        return 1;
    {
        wchar_t pipe_name[200];
        int i;
        for (i = 1; i < argc; i++) {
            if (wcscmp(argv[i], L"--no-autoload") == 0)
                forth_autoload_set(0);
        }
        if (companion_name(argc, argv, pipe_name, 200))
            rc = companion_run(pipe_name);
        else if (agent_requested(argc, argv))
            rc = agent_run(argc, argv);
        else
            rc = window_run(argv, show);
    }
    LocalFree(argv);
    return rc;
}
