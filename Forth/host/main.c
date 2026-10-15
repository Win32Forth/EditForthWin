#include "kernel_api.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <io.h>
#include <windows.h>

unsigned long long host_ms(void)
{
    return GetTickCount64();
}

/* File slots are 1-based. Slot 0 is never a file. */
#define HOST_FILES 16
#define HOST_PATH 1024
#define HOST_LOADS 8
#define HOST_REGS 64

static FILE *host_fp[HOST_FILES];
static char load_dir[HOST_LOADS][HOST_PATH];
static int load_len[HOST_LOADS];
static int load_n;
static char reg_path[HOST_REGS][256];
static int reg_len[HOST_REGS];
static int reg_n;
static char last_path[256];
static int last_len;

static int host_copy_path(const char *p, long long n, char *dst, size_t cap)
{
    if (p == NULL || n <= 0 || (unsigned long long)n >= cap)
        return 0;
    memcpy(dst, p, (size_t)n);
    dst[n] = '\0';
    return 1;
}

static int host_slot(void)
{
    for (int i = 1; i < HOST_FILES; i++) {
        if (host_fp[i] == NULL)
            return i;
    }
    return 0;
}

static FILE *host_lookup(long long id)
{
    if (id < 1 || id >= HOST_FILES)
        return NULL;
    return host_fp[id];
}

static int host_abs(const char *s, long long n)
{
    if (n >= 1 && (s[0] == '\\' || s[0] == '/'))
        return 1;
    if (n >= 2 && s[1] == ':' &&
        ((s[0] >= 'A' && s[0] <= 'Z') || (s[0] >= 'a' && s[0] <= 'z')))
        return 1;
    return 0;
}

long long host_open(const char *p, long long n, long long fam)
{
    char path[HOST_PATH];
    int slot;
    FILE *fp;
    const char *mode;

    if (!host_copy_path(p, n, path, sizeof path))
        return 0;
    slot = host_slot();
    if (slot == 0)
        return 0;
    mode = (fam == 2 || fam == 3) ? "r+b" : "rb";
    if (fopen_s(&fp, path, mode) != 0 || fp == NULL)
        return 0;
    host_fp[slot] = fp;
    return slot;
}

long long host_create(const char *p, long long n, long long fam)
{
    char path[HOST_PATH];
    int slot;
    FILE *fp;

    (void)fam;
    if (!host_copy_path(p, n, path, sizeof path))
        return 0;
    slot = host_slot();
    if (slot == 0)
        return 0;
    if (fopen_s(&fp, path, "w+b") != 0 || fp == NULL)
        return 0;
    host_fp[slot] = fp;
    return slot;
}

long long host_close(long long id)
{
    FILE *fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    host_fp[id] = NULL;
    return fclose(fp) == 0 ? 0 : -1;
}

long long host_read(char *buf, long long n, long long id)
{
    FILE *fp = host_lookup(id);
    size_t got;

    if (fp == NULL || buf == NULL || n < 0)
        return -1;
    if (n == 0)
        return 0;
    got = fread(buf, 1, (size_t)n, fp);
    if (got < (size_t)n && ferror(fp))
        return -1;
    return (long long)got;
}

long long host_write(const char *buf, long long n, long long id)
{
    FILE *fp = host_lookup(id);
    size_t put;

    if (fp == NULL || buf == NULL || n < 0)
        return -1;
    if (n == 0)
        return 0;
    put = fwrite(buf, 1, (size_t)n, fp);
    return put == (size_t)n ? 0 : -1;
}

long long host_size(long long id)
{
    FILE *fp = host_lookup(id);
    __int64 pos;
    __int64 sz;

    if (fp == NULL)
        return -1;
    pos = _ftelli64(fp);
    if (pos < 0)
        return -1;
    if (_fseeki64(fp, 0, SEEK_END) != 0)
        return -1;
    sz = _ftelli64(fp);
    _fseeki64(fp, pos, SEEK_SET);
    if (sz < 0)
        return -1;
    return (long long)sz;
}

long long host_repos(long long id, long long lo, long long hi)
{
    FILE *fp = host_lookup(id);
    if (fp == NULL || hi != 0)
        return -1;
    if (_fseeki64(fp, (__int64)lo, SEEK_SET) != 0)
        return -1;
    return 0;
}

long long host_flush(long long id)
{
    FILE *fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    return fflush(fp) == 0 ? 0 : -1;
}

void *host_alloc(unsigned long long n)
{
    return malloc(n == 0 ? 1 : (size_t)n);
}

void host_free(void *p)
{
    free(p);
}

long long host_resolve(const char *p, long long n, char *out, long long cap)
{
    char tmp[HOST_PATH];
    char joined[HOST_PATH];
    const char *src;
    DWORD need;
    size_t sl;

    if (out == NULL || cap < 2)
        return 0;
    if (p == NULL || n < 0)
        n = 0;
    if (n > HOST_PATH - 1)
        n = HOST_PATH - 1;
    if (n > 0)
        memcpy(tmp, p, (size_t)n);
    tmp[n] = '\0';
    src = tmp;
    if (!host_abs(tmp, n) && load_n > 0 && load_len[load_n - 1] > 0) {
        int dl = load_len[load_n - 1];
        size_t room;
        size_t cn;

        if (dl > HOST_PATH - 2)
            dl = HOST_PATH - 2;
        memcpy(joined, load_dir[load_n - 1], (size_t)dl);
        if (joined[dl - 1] != '\\' && joined[dl - 1] != '/')
            joined[dl++] = '\\';
        room = (size_t)(HOST_PATH - 1 - dl);
        cn = (size_t)n < room ? (size_t)n : room;
        memcpy(joined + dl, tmp, cn);
        joined[dl + cn] = '\0';
        src = joined;
    }
    need = GetFullPathNameA(src, (DWORD)cap, out, NULL);
    if (need == 0 || need >= (DWORD)cap) {
        sl = strlen(src);
        if (sl >= (size_t)cap)
            sl = (size_t)cap - 1;
        memcpy(out, src, sl);
        out[sl] = '\0';
        return (long long)sl;
    }
    return (long long)strlen(out);
}

void host_begin_load(const char *p, long long n)
{
    int len = 0;
    int found = 0;
    long long i;

    if (load_n >= HOST_LOADS)
        return;
    if (p == NULL || n < 0)
        n = 0;
    i = n;
    while (i > 0) {
        char c = p[i - 1];
        if (c == '\\' || c == '/') {
            found = 1;
            break;
        }
        i--;
    }
    if (found)
        len = (int)(i - 1);
    if (len < 0)
        len = 0;
    if (len >= HOST_PATH)
        len = HOST_PATH - 1;
    if (len > 0)
        memcpy(load_dir[load_n], p, (size_t)len);
    load_dir[load_n][len] = '\0';
    load_len[load_n] = len;
    load_n++;
}

void host_end_load(void)
{
    if (load_n > 0)
        load_n--;
}

static int host_eq(const char *a, int an, const char *b, int bn)
{
    if (an != bn)
        return 0;
    for (int i = 0; i < an; i++) {
        unsigned char ca = (unsigned char)a[i];
        unsigned char cb = (unsigned char)b[i];
        if (ca == '/')
            ca = '\\';
        if (cb == '/')
            cb = '\\';
        if (ca >= 'A' && ca <= 'Z')
            ca = (unsigned char)(ca + 32);
        if (cb >= 'A' && cb <= 'Z')
            cb = (unsigned char)(cb + 32);
        if (ca != cb)
            return 0;
    }
    return 1;
}

long long host_was_included(const char *p, long long n)
{
    int len;

    if (p == NULL || n <= 0)
        return 0;
    if (n > 255)
        n = 255;
    len = (int)n;
    for (int i = 0; i < reg_n; i++) {
        if (host_eq(reg_path[i], reg_len[i], p, len))
            return 1;
    }
    return 0;
}

void host_register(const char *p, long long n)
{
    if (p == NULL || n <= 0)
        return;
    if (n > 255)
        n = 255;
    memcpy(last_path, p, (size_t)n);
    last_path[n] = '\0';
    last_len = (int)n;
    if (reg_n >= HOST_REGS)
        return;
    if (host_was_included(p, n))
        return;
    memcpy(reg_path[reg_n], p, (size_t)n);
    reg_path[reg_n][n] = '\0';
    reg_len[reg_n] = (int)n;
    reg_n++;
}

void host_last_included(long long *addr, long long *len)
{
    if (addr != NULL)
        *addr = (long long)(ULONG_PTR)last_path;
    if (len != NULL)
        *len = last_len;
}

void host_dot_included(void)
{
    if (reg_n <= 0) {
        fputs("Included:\n  (none)\n", stdout);
        fflush(stdout);
        return;
    }
    fputs("Included:\n", stdout);
    for (int i = 0; i < reg_n; i++) {
        fputs("  ", stdout);
        fwrite(reg_path[i], 1, (size_t)reg_len[i], stdout);
        fputc('\n', stdout);
    }
    fflush(stdout);
}

static void emit_c(int c)
{
    fputc(c, stdout);
    fflush(stdout);
}

static int key_c(void)
{
    int c = getchar();
    return c == EOF ? -1 : c;
}

long long host_read_line(char *buf, long long n, long long id, long long *flag)
{
    FILE *fp = host_lookup(id);
    long long i = 0;
    int c;

    if (flag != NULL)
        *flag = 0;
    if (fp == NULL || n < 0 || (buf == NULL && n > 0))
        return -1;
    c = fgetc(fp);
    if (c == EOF)
        return ferror(fp) ? -1 : 0;
    if (flag != NULL)
        *flag = -1;
    for (;;) {
        if (c == '\n')
            return i;
        if (c == '\r') {
            int next = fgetc(fp);
            if (next == EOF) {
                if (ferror(fp))
                    return -1;
            } else if (next != '\n') {
                ungetc(next, fp);
            }
            return i;
        }
        if (i >= n) {
            ungetc(c, fp);
            return i;
        }
        buf[i++] = (char)c;
        c = fgetc(fp);
        if (c == EOF)
            return ferror(fp) ? -1 : i;
    }
}

long long host_write_line(const char *buf, long long n, long long id)
{
    char nl = '\n';

    if (host_write(buf, n, id) != 0)
        return -1;
    return host_write(&nl, 1, id);
}

long long host_position(long long id)
{
    FILE *fp = host_lookup(id);
    __int64 pos;

    if (fp == NULL)
        return -1;
    pos = _ftelli64(fp);
    if (pos < 0)
        return -1;
    return (long long)pos;
}

long long host_resize_file(long long id, long long lo, long long hi)
{
    FILE *fp = host_lookup(id);
    int fd;

    if (fp == NULL || hi != 0 || lo < 0)
        return -1;
    if (fflush(fp) != 0)
        return -1;
    fd = _fileno(fp);
    if (fd < 0)
        return -1;
    if (_chsize_s(fd, (__int64)lo) != 0)
        return -1;
    return 0;
}

long long host_delete(const char *p, long long n)
{
    char path[HOST_PATH];

    if (!host_copy_path(p, n, path, sizeof path))
        return -1;
    return DeleteFileA(path) ? 0 : -1;
}

long long host_rename(const char *a, long long an, const char *b, long long bn)
{
    char from[HOST_PATH];
    char to[HOST_PATH];

    if (!host_copy_path(a, an, from, sizeof from))
        return -1;
    if (!host_copy_path(b, bn, to, sizeof to))
        return -1;
    return MoveFileA(from, to) ? 0 : -1;
}

long long host_file_status(const char *p, long long n, long long *attr)
{
    char path[HOST_PATH];
    DWORD a;

    if (attr != NULL)
        *attr = 0;
    if (!host_copy_path(p, n, path, sizeof path))
        return -1;
    a = GetFileAttributesA(path);
    if (a == INVALID_FILE_ATTRIBUTES)
        return -1;
    if (attr != NULL)
        *attr = (long long)a;
    return 0;
}

void *host_resize(void *p, unsigned long long n)
{
    return realloc(p, n == 0 ? 1 : (size_t)n);
}

void host_sleep(unsigned long long ms)
{
    while (ms > 0) {
        unsigned long chunk = ms > 1000ull ? 1000ul : (unsigned long)ms;
        Sleep(chunk);
        ms -= chunk;
    }
}

void host_time_date(long long *out)
{
    SYSTEMTIME st;

    if (out == NULL)
        return;
    GetLocalTime(&st);
    out[0] = st.wSecond;
    out[1] = st.wMinute;
    out[2] = st.wHour;
    out[3] = st.wDay;
    out[4] = st.wMonth;
    out[5] = st.wYear;
}

long long host_chdir(const char *p, long long n)
{
    char path[HOST_PATH];
    char *s;

    if (!host_copy_path(p, n, path, sizeof path))
        return -1;
    for (s = path; *s != '\0'; s++) {
        if (*s == '/')
            *s = '\\';
    }
    return SetCurrentDirectoryA(path) ? 0 : -1;
}

void host_pwd(void)
{
    char buf[HOST_PATH];
    DWORD n = GetCurrentDirectoryA((DWORD)sizeof buf, buf);

    if (n == 0 || n >= sizeof buf)
        return;
    fputs(buf, stdout);
    fputc('\n', stdout);
    fflush(stdout);
}

long long host_cwd(char *buf, long long max)
{
    char tmp[HOST_PATH];
    DWORD n;
    long long copy;

    if (buf == NULL || max <= 0)
        return 0;
    n = GetCurrentDirectoryA((DWORD)sizeof tmp, tmp);
    if (n == 0 || n >= sizeof tmp)
        return 0;
    copy = (long long)n < max ? (long long)n : max;
    memcpy(buf, tmp, (size_t)copy);
    return copy;
}

static int host_has_wild(const char *s)
{
    for (; *s != '\0'; s++) {
        if (*s == '*' || *s == '?')
            return 1;
    }
    return 0;
}

void host_dir(const char *p, long long n)
{
    char spec[HOST_PATH];
    WIN32_FIND_DATAA fd;
    HANDLE h;
    size_t len = 0;
    char *s;

    if (p == NULL || n <= 0) {
        DWORD cn = GetCurrentDirectoryA((DWORD)sizeof spec, spec);
        if (cn == 0 || cn >= sizeof spec - 3)
            return;
        len = cn;
    } else {
        if (!host_copy_path(p, n, spec, sizeof spec))
            return;
        for (s = spec; *s != '\0'; s++) {
            if (*s == '/')
                *s = '\\';
        }
        len = strlen(spec);
    }
    if (!host_has_wild(spec)) {
        DWORD attr = GetFileAttributesA(spec);
        if (n <= 0 || (attr != INVALID_FILE_ATTRIBUTES &&
                       (attr & FILE_ATTRIBUTE_DIRECTORY) != 0)) {
            if (len > 0 && spec[len - 1] != '\\') {
                if (len + 3 >= sizeof spec)
                    return;
                spec[len++] = '\\';
            }
            if (len + 2 >= sizeof spec)
                return;
            spec[len++] = '*';
            spec[len] = '\0';
        }
    }
    h = FindFirstFileA(spec, &fd);
    if (h == INVALID_HANDLE_VALUE)
        return;
    do {
        if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0)
            continue;
        fputs(fd.cFileName, stdout);
        fputc('\n', stdout);
    } while (FindNextFileA(h, &fd));
    FindClose(h);
    fflush(stdout);
}

long long host_accept(char *buf, long long n)
{
    long long i = 0;
    int c;

    if (buf == NULL || n <= 0)
        return 0;
    while (i < n) {
        c = getchar();
        if (c == EOF || c == '\n')
            break;
        if (c == '\r')
            continue;
        buf[i++] = (char)c;
    }
    return i;
}

static int eval_buffer(const char *text, size_t n)
{
    int rc = kernel_eval(text, n);
    if (rc == 0) {
        fputs("ok\n", stdout);
        fflush(stdout);
    }
    return rc;
}

/* One kernel_eval of the whole file. kernel1.fth defines words across lines. */
static int eval_file(const char *path)
{
    FILE *fp = NULL;
    long sz;
    char *buf;
    size_t nread;
    int rc;

    if (fopen_s(&fp, path, "rb") != 0 || fp == NULL) {
        fprintf(stderr, "cannot open %s\n", path);
        return -1;
    }
    if (fseek(fp, 0, SEEK_END) != 0) {
        fclose(fp);
        fprintf(stderr, "cannot size %s\n", path);
        return -1;
    }
    sz = ftell(fp);
    if (sz < 0) {
        fclose(fp);
        fprintf(stderr, "cannot size %s\n", path);
        return -1;
    }
    if (fseek(fp, 0, SEEK_SET) != 0) {
        fclose(fp);
        fprintf(stderr, "cannot read %s\n", path);
        return -1;
    }
    buf = (char *)malloc((size_t)sz + 1);
    if (buf == NULL) {
        fclose(fp);
        fprintf(stderr, "out of memory\n");
        return -1;
    }
    nread = fread(buf, 1, (size_t)sz, fp);
    fclose(fp);
    buf[nread] = '\0';
    rc = eval_buffer(buf, nread);
    free(buf);
    return rc;
}

int main(int argc, char **argv)
{
    char line[1024];

    kernel_set_emit(emit_c);
    kernel_set_key(key_c);
    if (kernel_init() != 0) {
        fprintf(stderr, "kernel_init failed\n");
        return 1;
    }

    fputs("=== EditForthWin 1.0.0 === Oct 15, 2026 3:28 PM ===\n", stdout);
    fflush(stdout);

    for (int i = 1; i < argc; i++) {
        int rc = eval_file(argv[i]);
        if (rc != 0)
            return 1;
    }

    for (;;) {
        if (fgets(line, (int)sizeof line, stdin) == NULL)
            break;
        size_t n = strlen(line);
        while (n > 0 && (line[n - 1] == '\n' || line[n - 1] == '\r'))
            line[--n] = '\0';
        if (eval_buffer(line, n) != 0)
            break;
    }
    return 0;
}
