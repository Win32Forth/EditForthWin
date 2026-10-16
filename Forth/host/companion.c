/* Public domain.
   Headless companion for the editor. Serves a named pipe, boots the kernel,
   and evaluates one line per message. The editor owns the console pane. */

#include "kernel_api.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

void host_set_sink(void (*fn)(const void *, size_t));
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

int companion_run(const wchar_t *pipe_name)
{
    wchar_t path[300];
    char op[32];
    char *body = NULL;
    int rc = 1;

    if (pipe_name == NULL || pipe_name[0] == L'\0')
        pipe_name = L"EditForthWin";
    _snwprintf_s(path, 300, _TRUNCATE, L"\\\\.\\pipe\\%s", pipe_name);
    g_pipe = CreateNamedPipeW(path, PIPE_ACCESS_DUPLEX,
                              PIPE_TYPE_BYTE | PIPE_READMODE_BYTE | PIPE_WAIT,
                              1, 65536, 65536, 0, NULL);
    if (g_pipe == INVALID_HANDLE_VALUE)
        return 1;
    if (!ConnectNamedPipe(g_pipe, NULL)) {
        if (GetLastError() != ERROR_PIPE_CONNECTED)
            goto done;
    }

    host_set_sink(companion_sink);
    if (forth_boot() != 0) {
        companion_flush();
        goto done;
    }
    companion_flush();
    companion_send_cwd();
    forth_prompt();
    companion_flush();

    for (;;) {
        unsigned char hdr[4];
        unsigned long n;
        char text[8192];
        int tn;

        if (!read_full(hdr, 4))
            break;
        n = (unsigned long)hdr[0] | ((unsigned long)hdr[1] << 8) |
            ((unsigned long)hdr[2] << 16) | ((unsigned long)hdr[3] << 24);
        if (n == 0 || n > COMPANION_MSG)
            break;
        body = (char *)malloc(n + 1);
        if (body == NULL)
            break;
        if (!read_full(body, (int)n))
            break;
        body[n] = '\0';
        if (json_string_field(body, "op", op, (int)sizeof op) < 0) {
            free(body);
            body = NULL;
            continue;
        }
        if (strcmp(op, "quit") == 0) {
            rc = 0;
            break;
        }
        if (strcmp(op, "eval") == 0) {
            tn = json_string_field(body, "text", text, (int)sizeof text);
            free(body);
            body = NULL;
            if (tn < 0)
                continue;
            trim_line(text);
            if (companion_is_bye(text)) {
                pipe_send("{\"op\":\"bye\"}");
                rc = 0;
                break;
            }
            forth_eval(text, strlen(text));
            companion_flush();
            companion_send_cwd();
            forth_prompt();
            companion_flush();
            continue;
        }
        free(body);
        body = NULL;
    }

done:
    free(body);
    if (g_pipe != INVALID_HANDLE_VALUE) {
        DisconnectNamedPipe(g_pipe);
        CloseHandle(g_pipe);
        g_pipe = INVALID_HANDLE_VALUE;
    }
    return rc;
}
