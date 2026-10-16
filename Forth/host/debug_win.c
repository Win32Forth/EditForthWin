/* Public domain. Editor debug span and pause paint for the companion pipe. */

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern uint64_t debug_armed;
extern uint64_t debug_busy;
extern uint64_t debug_cfa;
extern uint64_t debug_xt;
extern unsigned char debug_name[];
extern unsigned char view_paths[];
extern uint64_t view_file_n;

static int64_t span_off;
static int64_t span_len;
static void (*debug_flush)(void);
static void (*debug_send)(const char *json);

void host_debug_set_notify(void (*flush)(void), void (*send)(const char *json))
{
    debug_flush = flush;
    debug_send = send;
}

void host_debug_set_span(int64_t off, int64_t len)
{
    if (len > 0 && off >= 0) {
        span_off = off;
        span_len = len;
    } else {
        span_off = 0;
        span_len = 0;
    }
}

void host_debug_get_span(int64_t *off, int64_t *len)
{
    if (off != 0)
        *off = span_off;
    if (len != 0)
        *len = span_len;
}

static int append_json(char *dst, int n, int cap, const char *s)
{
    int i;

    for (i = 0; s[i] != '\0'; i++) {
        unsigned char c = (unsigned char)s[i];
        if (n + 2 >= cap)
            return -1;
        if (c == '"' || c == '\\') {
            dst[n++] = '\\';
            dst[n++] = (char)c;
        } else if (c == '\n') {
            dst[n++] = '\\';
            dst[n++] = 'n';
        } else if (c < 0x20) {
            dst[n++] = ' ';
        } else {
            dst[n++] = (char)c;
        }
    }
    return n;
}

static int stamped_path(uint64_t cfa, char *path, int cap, int *line)
{
    uint64_t flags;
    uint64_t file;
    uint64_t ln;
    const unsigned char *slot;
    int n;

    if (cfa == 0 || (cfa & 7) != 0 || cap < 2)
        return 0;
    flags = *(uint64_t *)(uintptr_t)(cfa - 8);
    ln = (flags >> 32) & 0xFFFFULL;
    file = (flags >> 48) & 0x1FFFULL;
    if (ln == 0 || file == 0 || file > view_file_n || file > 256)
        return 0;
    slot = view_paths + (size_t)(file - 1) * 256;
    n = slot[0];
    if (n <= 0 || n > 255)
        return 0;
    if (n >= cap)
        n = cap - 1;
    memcpy(path, slot + 1, (size_t)n);
    path[n] = '\0';
    *line = (int)ln;
    return 1;
}

static void copy_pause_name(char *dst, int cap)
{
    int n;
    int i;

    dst[0] = '\0';
    if (cap < 2)
        return;
    n = debug_name[0];
    if (n <= 0 || n > 31)
        return;
    if (n >= cap)
        n = cap - 1;
    for (i = 0; i < n; i++) {
        unsigned char c = debug_name[1 + i];
        if (c < 32 || c > 126) {
            dst[0] = '\0';
            return;
        }
        dst[i] = (char)c;
    }
    dst[n] = '\0';
}

void host_debug_paint(void)
{
    char path[512];
    char name[40];
    char json[2048];
    int line = 0;
    int off = 0;
    int len = 0;
    int armed;
    int paused;
    int k;

    armed = debug_armed != 0;
    paused = armed && debug_busy != 0;
    path[0] = '\0';
    name[0] = '\0';
    if (paused) {
        if (!stamped_path(debug_cfa, path, (int)sizeof path, &line)) {
            line = 0;
            path[0] = '\0';
            if (!stamped_path(debug_xt, path, (int)sizeof path, &line)) {
                line = 0;
                path[0] = '\0';
            }
        }
        copy_pause_name(name, (int)sizeof name);
        if (span_len > 0 && span_off >= 0 && span_off <= 0x7FFFFFFF && span_len <= 0x7FFFFFFF) {
            off = (int)span_off;
            len = (int)span_len;
        }
    }
    span_off = 0;
    span_len = 0;
    if (debug_flush != 0)
        debug_flush();
    if (debug_send == 0)
        return;
    k = snprintf(json, sizeof json,
                 "{\"op\":\"debug\",\"armed\":%d,\"paused\":%d,\"line\":%d,\"off\":%d,\"len\":%d,\"name\":\"",
                 armed, paused, line, off, len);
    if (k < 0 || k >= (int)sizeof json)
        return;
    k = append_json(json, k, (int)sizeof json, name);
    if (k < 0 || k + 10 >= (int)sizeof json)
        return;
    memcpy(json + k, "\",\"path\":\"", 10);
    k += 10;
    k = append_json(json, k, (int)sizeof json, path);
    if (k < 0 || k + 3 >= (int)sizeof json)
        return;
    json[k++] = '"';
    json[k++] = '}';
    json[k] = '\0';
    debug_send(json);
}
