/* Public domain.
   Headless companion for the editor. Serves a named pipe, boots the kernel,
   and evaluates one line per message. The editor owns the console pane. */

#include "kernel_api.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

void host_debug_set_notify(void (*flush)(void), void (*send)(const char *json));
void forth_autoload(void);
void forth_set_key_hook(int (*fn)(void));

extern uint64_t debug_busy;
extern uint64_t debug_armed;
extern uint64_t debug_break_asap;
extern uint64_t debug_bp_go;
extern uint64_t debug_bp_xts[8];
extern uint64_t debug_bp_en[8];
extern uint64_t debug_runto_ip;
extern uint64_t debug_runto_off;
extern uint64_t debug_runto_status;
extern uint64_t last_cfa;
extern uint64_t view_file_n;
extern unsigned char view_paths[];
/* ARM64 _find_word is a C function. The x64 image is a register-file
   translation and must be entered through host_find_word. */
#if defined(_M_X64)
extern uint64_t host_find_word(const char *token, uint64_t len);
#define find_word host_find_word
#else
extern uint64_t _find_word(const char *token, uint64_t len);
#define find_word _find_word
#endif
void host_user_tree(int mode);

void host_set_sink(void (*fn)(const void *, size_t));
void host_set_edit(void (*fn)(const char *path, int kind));
void host_set_edit_at(void (*fn)(const char *path, long long line));
void host_edit_at(const char *p, long long n, long long line);
void host_outs(const char *s);
int forth_eval(const char *text, size_t n);
void forth_prompt(void);
int forth_boot(void);

#define COMPANION_OUT 65536
#define COMPANION_MSG (4 * 1024 * 1024)

static HANDLE g_pipe = INVALID_HANDLE_VALUE;
static char g_out[COMPANION_OUT];
static int g_out_n;

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

static int pipe_write(const void *p, size_t n)
{
    const char *s = (const char *)p;
    while (n > 0) {
        DWORD wrote = 0;
        if (g_pipe == INVALID_HANDLE_VALUE)
            return 0;
        if (!WriteFile(g_pipe, s, (DWORD)n, &wrote, NULL) || wrote == 0)
            return 0;
        s += wrote;
        n -= wrote;
    }
    return 1;
}

static int pipe_send(const char *json)
{
    unsigned long n;
    unsigned char hdr[4];

    if (json == NULL)
        return 0;
    n = (unsigned long)strlen(json);
    hdr[0] = (unsigned char)n;
    hdr[1] = (unsigned char)(n >> 8);
    hdr[2] = (unsigned char)(n >> 16);
    hdr[3] = (unsigned char)(n >> 24);
    return pipe_write(hdr, 4) && pipe_write(json, n);
}

static int pipe_send_text(const char *op, const char *text, int n)
{
    static const char hex[] = "0123456789abcdef";
    char *json;
    int i;
    int cap;
    int k;
    int rc;
    int op_n;

    op_n = (int)strlen(op);
    cap = 32 + op_n + n * 6;
    json = (char *)malloc((size_t)cap);
    if (json == NULL)
        return 0;
    k = snprintf(json, (size_t)cap, "{\"op\":\"%s\",\"text\":\"", op);
    if (k < 0 || k >= cap) {
        free(json);
        return 0;
    }
    for (i = 0; i < n; i++) {
        unsigned char c = (unsigned char)text[i];
        if (c == '"' || c == '\\') {
            json[k++] = '\\';
            json[k++] = (char)c;
        } else if (c == '\n') {
            json[k++] = '\\';
            json[k++] = 'n';
        } else if (c == '\r') {
            json[k++] = '\\';
            json[k++] = 'r';
        } else if (c == '\t') {
            json[k++] = '\\';
            json[k++] = 't';
        } else if (c < 0x20) {
            json[k++] = '\\';
            json[k++] = 'u';
            json[k++] = '0';
            json[k++] = '0';
            json[k++] = hex[c >> 4];
            json[k++] = hex[c & 15];
        } else {
            json[k++] = (char)c;
        }
    }
    json[k++] = '"';
    json[k++] = '}';
    json[k] = '\0';
    rc = pipe_send(json);
    free(json);
    return rc;
}

/* edit plus a 1-based line. Line 0 opens the file and leaves the caret. */
static int pipe_send_edit(const char *text, int n, long long line)
{
    static const char hex[] = "0123456789abcdef";
    char tail[48];
    char *json;
    int i;
    int cap;
    int k;
    int rc;
    int tail_n;

    if (text == NULL) {
        text = "";
        n = 0;
    }
    if (n < 0)
        n = 0;
    tail_n = snprintf(tail, sizeof tail, "\",\"line\":%lld}", line);
    if (tail_n < 0 || tail_n >= (int)sizeof tail)
        return 0;
    cap = 32 + n * 6 + tail_n;
    json = (char *)malloc((size_t)cap);
    if (json == NULL)
        return 0;
    k = snprintf(json, (size_t)cap, "{\"op\":\"edit\",\"text\":\"");
    if (k < 0 || k >= cap) {
        free(json);
        return 0;
    }
    for (i = 0; i < n; i++) {
        unsigned char c = (unsigned char)text[i];
        if (k + 6 + tail_n >= cap) {
            free(json);
            return 0;
        }
        if (c == '"' || c == '\\') {
            json[k++] = '\\';
            json[k++] = (char)c;
        } else if (c == '\n') {
            json[k++] = '\\';
            json[k++] = 'n';
        } else if (c == '\r') {
            json[k++] = '\\';
            json[k++] = 'r';
        } else if (c == '\t') {
            json[k++] = '\\';
            json[k++] = 't';
        } else if (c < 0x20) {
            json[k++] = '\\';
            json[k++] = 'u';
            json[k++] = '0';
            json[k++] = '0';
            json[k++] = hex[c >> 4];
            json[k++] = hex[c & 15];
        } else {
            json[k++] = (char)c;
        }
    }
    if (k + tail_n >= cap) {
        free(json);
        return 0;
    }
    memcpy(json + k, tail, (size_t)tail_n + 1);
    rc = pipe_send(json);
    free(json);
    return rc;
}

static int pipe_send_out(const char *text, int n)
{
    return pipe_send_text("out", text, n);
}

static void companion_send_cwd(void)
{
    char buf[1024];
    DWORD n = GetCurrentDirectoryA((DWORD)sizeof buf, buf);

    if (n == 0 || n >= sizeof buf)
        return;
    pipe_send_text("cwd", buf, (int)n);
}

static void companion_flush_n(int n)
{
    if (n <= 0)
        return;
    if (n > g_out_n)
        n = g_out_n;
    pipe_send_out(g_out, n);
    g_out_n -= n;
    if (g_out_n > 0)
        memmove(g_out, g_out + n, (size_t)g_out_n);
}

static void companion_flush(void)
{
    companion_flush_n(g_out_n);
}

static void companion_sink(const void *p, size_t n)
{
    const char *s = (const char *)p;

    while (n > 0) {
        size_t room = (size_t)(COMPANION_OUT - g_out_n);
        size_t take = n < room ? n : room;
        int keep;
        memcpy(g_out + g_out_n, s, take);
        g_out_n += (int)take;
        s += take;
        n -= take;
        if (g_out_n < COMPANION_OUT)
            continue;
        keep = utf8_tail(g_out, g_out_n);
        if (keep >= g_out_n)
            keep = 0;
        companion_flush_n(g_out_n - keep);
    }
}

static int read_full(void *dst, int n)
{
    char *p = (char *)dst;
    while (n > 0) {
        DWORD got = 0;
        if (!ReadFile(g_pipe, p, (DWORD)n, &got, NULL) || got == 0)
            return 0;
        p += got;
        n -= (int)got;
    }
    return 1;
}

static int hex_nibble(char c)
{
    if (c >= '0' && c <= '9')
        return c - '0';
    if (c >= 'a' && c <= 'f')
        return c - 'a' + 10;
    if (c >= 'A' && c <= 'F')
        return c - 'A' + 10;
    return -1;
}

static int append_utf8(char *dst, int n, int cap, unsigned code)
{
    if (code < 0x80) {
        if (n + 1 >= cap)
            return -1;
        dst[n++] = (char)code;
        return n;
    }
    if (code < 0x800) {
        if (n + 2 >= cap)
            return -1;
        dst[n++] = (char)(0xC0 | (code >> 6));
        dst[n++] = (char)(0x80 | (code & 0x3F));
        return n;
    }
    if (n + 3 >= cap)
        return -1;
    dst[n++] = (char)(0xE0 | (code >> 12));
    dst[n++] = (char)(0x80 | ((code >> 6) & 0x3F));
    dst[n++] = (char)(0x80 | (code & 0x3F));
    return n;
}

/* Copy a JSON string after the opening quote. Returns length, or -1. */
static int json_unescape(const char *s, char *dst, int cap)
{
    int n = 0;

    while (*s != '\0' && *s != '"') {
        unsigned char c = (unsigned char)*s++;
        unsigned code;
        if (c == '\\') {
            char e = *s++;
            if (e == '\0')
                return -1;
            if (e == 'n')
                code = '\n';
            else if (e == 'r')
                code = '\r';
            else if (e == 't')
                code = '\t';
            else if (e == 'u') {
                int h0 = hex_nibble(s[0]);
                int h1 = hex_nibble(s[1]);
                int h2 = hex_nibble(s[2]);
                int h3 = hex_nibble(s[3]);
                if (h0 < 0 || h1 < 0 || h2 < 0 || h3 < 0)
                    return -1;
                code = (unsigned)((h0 << 12) | (h1 << 8) | (h2 << 4) | h3);
                s += 4;
            } else {
                code = (unsigned char)e;
            }
        } else {
            code = c;
        }
        n = append_utf8(dst, n, cap, code);
        if (n < 0)
            return -1;
    }
    if (*s != '"')
        return -1;
    dst[n] = '\0';
    return n;
}

static int json_string_field(const char *json, const char *key, char *dst, int cap)
{
    char pat[32];
    const char *p;
    int klen;

    klen = snprintf(pat, sizeof pat, "\"%s\"", key);
    if (klen <= 0 || klen >= (int)sizeof pat)
        return -1;
    p = json;
    while ((p = strstr(p, pat)) != NULL) {
        const char *s = p + klen;
        while (*s == ' ' || *s == '\t')
            s++;
        if (*s != ':') {
            p += klen;
            continue;
        }
        s++;
        while (*s == ' ' || *s == '\t')
            s++;
        if (*s != '"')
            return -1;
        return json_unescape(s + 1, dst, cap);
    }
    return -1;
}

static int companion_is_bye(const char *s)
{
    while (*s == ' ' || *s == '\t')
        s++;
    if ((s[0] == 'B' || s[0] == 'b') &&
        (s[1] == 'Y' || s[1] == 'y') &&
        (s[2] == 'E' || s[2] == 'e')) {
        s += 3;
        while (*s == ' ' || *s == '\t' || *s == '\r' || *s == '\n')
            s++;
        return *s == '\0';
    }
    return 0;
}

static void trim_line(char *s)
{
    int n = (int)strlen(s);
    while (n > 0 && (s[n - 1] == '\n' || s[n - 1] == '\r' || s[n - 1] == ' ' || s[n - 1] == '\t'))
        s[--n] = '\0';
}

static volatile LONG g_evaluating;
static volatile LONG g_quit_req;
static HANDLE g_break_ev = NULL;
static HANDLE g_break_stop = NULL;
static HANDLE g_break_thread = NULL;

static int xt_name(uint64_t xt, char *dst, int cap)
{
    uint64_t flags;
    uint64_t off;
    const unsigned char *nfa;
    int n;
    int i;

    dst[0] = '\0';
    if (xt == 0 || (xt & 7) != 0 || cap < 2)
        return 0;
    flags = *(uint64_t *)(uintptr_t)(xt - 8);
    off = flags & 0xFFFFULL;
    if (off == 0 || off >= 4096)
        return 0;
    nfa = (const unsigned char *)(uintptr_t)(xt - off);
    n = nfa[0] & 0x7F;
    if (n <= 0 || n >= 64 || n >= cap)
        return 0;
    for (i = 0; i < n; i++) {
        unsigned char c = nfa[1 + i];
        if (c < 32 || c > 126)
            return 0;
        dst[i] = (char)c;
    }
    dst[n] = '\0';
    return n;
}

static void send_breaks(void)
{
    char text[8 * 80];
    int k = 0;
    int i;

    text[0] = '\0';
    for (i = 0; i < 8; i++) {
        char name[64];
        int n;
        if (debug_bp_xts[i] == 0)
            continue;
        if (!xt_name(debug_bp_xts[i], name, (int)sizeof name))
            continue;
        n = snprintf(text + k, sizeof text - (size_t)k, "%d\t%s\t%d\n",
                     i, name, debug_bp_en[i] != 0);
        if (n < 0 || k + n >= (int)sizeof text)
            break;
        k += n;
    }
    pipe_send_text("breaks", text, k);
}

static void break_enable(int index, int on)
{
    if (index < 0 || index >= 8)
        return;
    if (debug_bp_xts[index] == 0)
        return;
    debug_bp_en[index] = on ? ~(uint64_t)0 : 0;
}

static void break_clear(int index)
{
    if (index < 0 || index >= 8)
        return;
    debug_bp_xts[index] = 0;
    debug_bp_en[index] = 0;
}

static void send_last_name(void)
{
    char name[64];

    if (!xt_name(last_cfa, name, (int)sizeof name))
        pipe_send_text("last", "", 0);
    else
        pipe_send_text("last", name, (int)strlen(name));
}

/* VIEW stamp on the word. host_edit_at resolves Library/… the same way
   typed VIEW does, under Documents\EditForthWin, then opens that file. */
static void send_view(const char *name)
{
    char token[64];
    char path[256];
    char msg[96];
    uint64_t xt;
    uint64_t flags;
    unsigned line;
    unsigned file;
    const unsigned char *slot;
    int n;
    size_t len;

    if (name == NULL)
        name = "";
    while (*name == ' ' || *name == '\t')
        name++;
    len = strlen(name);
    while (len > 0 && (name[len - 1] == ' ' || name[len - 1] == '\t'))
        len--;
    if (len == 0 || len >= sizeof token) {
        pipe_send_text("err", "VIEW needs a single token", 25);
        return;
    }
    memcpy(token, name, len);
    token[len] = '\0';
    if (strchr(token, ' ') != NULL || strchr(token, '\t') != NULL) {
        pipe_send_text("err", "VIEW needs a single token", 25);
        return;
    }
    xt = find_word(token, (uint64_t)len);
    if (xt == 0 || (xt & 7) != 0) {
        n = snprintf(msg, sizeof msg, "undefined: %.60s", token);
        if (n > 0)
            pipe_send_text("err", msg, n);
        return;
    }
    flags = *(uint64_t *)(uintptr_t)(xt - 8);
    line = (unsigned)((flags >> 32) & 0xFFFFULL);
    file = (unsigned)((flags >> 48) & 0x1FFFULL);
    if (file == 0 || file > view_file_n || file > 256) {
        n = snprintf(msg, sizeof msg, "no source stamp for %.60s", token);
        if (n > 0)
            pipe_send_text("err", msg, n);
        return;
    }
    slot = view_paths + (size_t)(file - 1) * 256;
    n = slot[0];
    if (n <= 0 || n > 255) {
        n = snprintf(msg, sizeof msg, "no source stamp for %.60s", token);
        if (n > 0)
            pipe_send_text("err", msg, n);
        return;
    }
    memcpy(path, slot + 1, (size_t)n);
    path[n] = '\0';
    host_edit_at(path, n, (long long)line);
}

static int break_toggle(const char *name)
{
    uint64_t xt;
    size_t n;
    int i;
    int empty = -1;

    if (name == NULL)
        return 0;
    while (*name == ' ' || *name == '\t')
        name++;
    n = strlen(name);
    while (n > 0 && (name[n - 1] == ' ' || name[n - 1] == '\t'))
        n--;
    if (n == 0 || n >= 64)
        return 0;
    xt = find_word(name, (uint64_t)n);
    if (xt == 0)
        return 0;
    for (i = 0; i < 8; i++) {
        if (debug_bp_xts[i] == xt) {
            debug_bp_xts[i] = 0;
            debug_bp_en[i] = 0;
            return 2;
        }
        if (debug_bp_xts[i] == 0 && empty < 0)
            empty = i;
    }
    if (empty < 0)
        return -1;
    debug_bp_xts[empty] = xt;
    debug_bp_en[empty] = ~(uint64_t)0;
    return 1;
}

/* 1 = handled. The caller keeps reading. */
static int handle_side(const char *op, const char *text)
{
    if (strcmp(op, "breaks") == 0) {
        send_breaks();
        return 1;
    }
    if (strcmp(op, "break-en") == 0) {
        int index = 0;
        int on = 0;
        if (sscanf_s(text, "%d,%d", &index, &on) == 2)
            break_enable(index, on);
        send_breaks();
        return 1;
    }
    if (strcmp(op, "break-clr") == 0) {
        break_clear(atoi(text));
        send_breaks();
        return 1;
    }
    if (strcmp(op, "break-toggle") == 0) {
        int rc = break_toggle(text);
        char msg[96];
        if (rc == 0) {
            snprintf(msg, sizeof msg, "undefined: %.60s", text);
            pipe_send_text("err", msg, (int)strlen(msg));
        } else if (rc < 0) {
            pipe_send_text("err", "BREAK table full", (int)strlen("BREAK table full"));
        }
        send_breaks();
        return 1;
    }
    if (strcmp(op, "last") == 0) {
        send_last_name();
        return 1;
    }
    if (strcmp(op, "view") == 0) {
        send_view(text);
        return 1;
    }
    if (strcmp(op, "tree") == 0) {
        if (strcmp(text, "replace") == 0)
            host_user_tree(1);
        else if (strcmp(text, "rename") == 0)
            host_user_tree(2);
        else
            host_user_tree(0);
        companion_send_cwd();
        return 1;
    }
    return 0;
}

/* 1 = a message, 0 = pipe closed, -1 = skip this body. */
static int read_message(char *op, int opcap, char *text, int textcap)
{
    unsigned char hdr[4];
    unsigned long n;
    char *body;
    int tn;

    op[0] = '\0';
    text[0] = '\0';
    if (!read_full(hdr, 4))
        return 0;
    n = (unsigned long)hdr[0] | ((unsigned long)hdr[1] << 8) |
        ((unsigned long)hdr[2] << 16) | ((unsigned long)hdr[3] << 24);
    if (n == 0 || n > COMPANION_MSG)
        return 0;
    body = (char *)malloc(n + 1);
    if (body == NULL)
        return 0;
    if (!read_full(body, (int)n)) {
        free(body);
        return 0;
    }
    body[n] = '\0';
    if (json_string_field(body, "op", op, opcap) < 0) {
        free(body);
        return -1;
    }
    tn = json_string_field(body, "text", text, textcap);
    if (tn < 0)
        text[0] = '\0';
    free(body);
    return 1;
}

static int companion_key(void)
{
    char op[32];
    char text[8192];
    static const char paused[] = "debugger paused - use Step, Continue, or Stop";

    if (debug_busy == 0)
        return -1;
    for (;;) {
        int got;
        if (g_quit_req)
            return 27;
        companion_flush();
        got = read_message(op, (int)sizeof op, text, (int)sizeof text);
        if (got == 0) {
            g_quit_req = 1;
            return 27;
        }
        if (got < 0)
            continue;
        if (strcmp(op, "quit") == 0) {
            g_quit_req = 1;
            return 27;
        }
        if (strcmp(op, "key") == 0)
            return (int)strtol(text, NULL, 10);
        if (strcmp(op, "arm") == 0) {
            debug_bp_go = 1;
            return 'g';
        }
        if (strcmp(op, "runto") == 0) {
            debug_runto_off = _strtoui64(text, NULL, 10);
            debug_runto_ip = 0;
            debug_runto_status = 0;
            return 135;
        }
        if (handle_side(op, text))
            continue;
        if (strcmp(op, "eval") == 0)
            pipe_send_text("err", paused, (int)sizeof paused - 1);
    }
}

static DWORD WINAPI break_waiter(LPVOID unused)
{
    HANDLE waits[2];

    (void)unused;
    waits[0] = g_break_ev;
    waits[1] = g_break_stop;
    for (;;) {
        DWORD w = WaitForMultipleObjects(2, waits, FALSE, INFINITE);
        if (w != WAIT_OBJECT_0)
            break;
        if (debug_busy == 0 && (g_evaluating != 0 || debug_armed != 0))
            debug_break_asap = 1;
    }
    return 0;
}

static void break_start(const wchar_t *pipe_name)
{
    wchar_t name[320];

    if (pipe_name == NULL || pipe_name[0] == L'\0')
        pipe_name = L"EditForthWin";
    _snwprintf_s(name, 320, _TRUNCATE, L"Local\\%s-break", pipe_name);
    g_break_ev = CreateEventW(NULL, FALSE, FALSE, name);
    g_break_stop = CreateEventW(NULL, TRUE, FALSE, NULL);
    if (g_break_ev == NULL || g_break_stop == NULL)
        return;
    g_break_thread = CreateThread(NULL, 0, break_waiter, NULL, 0, NULL);
}

static void break_stop(void)
{
    if (g_break_stop != NULL)
        SetEvent(g_break_stop);
    if (g_break_thread != NULL) {
        WaitForSingleObject(g_break_thread, 1000);
        CloseHandle(g_break_thread);
        g_break_thread = NULL;
    }
    if (g_break_ev != NULL) {
        CloseHandle(g_break_ev);
        g_break_ev = NULL;
    }
    if (g_break_stop != NULL) {
        CloseHandle(g_break_stop);
        g_break_stop = NULL;
    }
}

static void companion_send_json(const char *json)
{
    pipe_send(json);
}

static void companion_edit(const char *path, int kind)
{
    char buf[1024];
    int n;

    if (path == NULL)
        path = "";
    n = (int)strlen(path);
    if (kind == 0) {
        pipe_send_text("edit", path, n);
        return;
    }
    if (n <= 0) {
        pipe_send_text("edit", "", 0);
        return;
    }
    if (n >= (int)sizeof buf - 1)
        n = (int)sizeof buf - 2;
    memcpy(buf, path, (size_t)n);
    if (buf[n - 1] != '\\' && buf[n - 1] != '/')
        buf[n++] = '\\';
    buf[n] = '\0';
    pipe_send_text("edit", buf, n);
}

static void companion_edit_at(const char *path, long long line)
{
    int n;

    if (path == NULL)
        path = "";
    n = (int)strlen(path);
    pipe_send_edit(path, n, line);
}

int companion_run(const wchar_t *pipe_name)
{
    wchar_t path[300];
    int rc = 1;

    if (pipe_name == NULL || pipe_name[0] == L'\0')
        pipe_name = L"EditForthWin";
    _snwprintf_s(path, 300, _TRUNCATE, L"\\\\.\\pipe\\%s", pipe_name);
    g_pipe = CreateNamedPipeW(path, PIPE_ACCESS_DUPLEX,
                              PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
                              1, 65536, 65536, 0, NULL);
    if (g_pipe == INVALID_HANDLE_VALUE)
        return 1;
    break_start(pipe_name);
    if (!ConnectNamedPipe(g_pipe, NULL)) {
        if (GetLastError() != ERROR_PIPE_CONNECTED)
            goto done;
    }

    host_set_sink(companion_sink);
    host_debug_set_notify(companion_flush, companion_send_json);
    host_set_edit(companion_edit);
    host_set_edit_at(companion_edit_at);
    forth_set_key_hook(companion_key);
    if (forth_boot() != 0) {
        companion_flush();
        goto done;
    }
    {
        char msg[256];
        int n = snprintf(msg, sizeof msg, "%s\n%s\n%s",
                         kernel_version, kernel_built, kernel_console);
        if (n > 0)
            pipe_send_text("version", msg, n);
    }
    forth_autoload();
    companion_flush();
    companion_send_cwd();
    forth_prompt();
    companion_flush();

    for (;;) {
        char op[32];
        char text[8192];
        int got = read_message(op, (int)sizeof op, text, (int)sizeof text);

        if (g_quit_req) {
            rc = 0;
            break;
        }
        if (got == 0)
            break;
        if (got < 0)
            continue;
        if (strcmp(op, "quit") == 0) {
            rc = 0;
            break;
        }
        if (handle_side(op, text))
            continue;
        if (strcmp(op, "key") == 0 || strcmp(op, "arm") == 0)
            continue;
        if (strcmp(op, "runto") == 0) {
            pipe_send_text("err", "Run to Here needs a pause", 25);
            continue;
        }
        if (strcmp(op, "eval") != 0)
            continue;
        trim_line(text);
        if (companion_is_bye(text)) {
            pipe_send("{\"op\":\"bye\"}");
            rc = 0;
            break;
        }
        g_evaluating = 1;
        forth_eval(text, strlen(text));
        g_evaluating = 0;
        if (g_quit_req) {
            rc = 0;
            break;
        }
        companion_flush();
        companion_send_cwd();
        forth_prompt();
        companion_flush();
    }

done:
    host_debug_set_notify(NULL, NULL);
    host_set_edit(NULL);
    host_set_edit_at(NULL);
    break_stop();
    if (g_pipe != INVALID_HANDLE_VALUE) {
        DisconnectNamedPipe(g_pipe);
        CloseHandle(g_pipe);
        g_pipe = INVALID_HANDLE_VALUE;
    }
    return rc;
}
