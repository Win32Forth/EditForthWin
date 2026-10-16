#include "kernel_api.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <io.h>
#include <windows.h>

extern unsigned char data_stack[];
extern unsigned long long vm_dsp;

static void sink_discard(const void *p, size_t n)
{
    (void)p;
    (void)n;
}

static void (*host_sink)(const void *, size_t) = sink_discard;
static int (*key_hook)(void);

void host_set_sink(void (*fn)(const void *, size_t))
{
    host_sink = fn != NULL ? fn : sink_discard;
}

void host_out(const void *p, size_t n)
{
    if (p != NULL && n != 0)
        host_sink(p, n);
}

void host_outs(const char *s)
{
    if (s != NULL && s[0] != '\0')
        host_out(s, strlen(s));
}

void forth_set_key_hook(int (*fn)(void))
{
    key_hook = fn;
}

long long forth_depth(void)
{
    unsigned long long sp0;

    sp0 = (unsigned long long)(uintptr_t)data_stack + 4096ULL;
    if (vm_dsp == 0 || vm_dsp > sp0)
        return 0;
    return (long long)((sp0 - vm_dsp) / 8ULL);
}

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
static char load_prev[HOST_LOADS][HOST_PATH];
static int load_len[HOST_LOADS];
static int load_n;
static int fromlib_armed;
static char user_root[HOST_PATH];
static char library_root[HOST_PATH];
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

static void host_slashes(char *s)
{
    for (; s != NULL && *s != '\0'; s++) {
        if (*s == '/')
            *s = '\\';
    }
}

static int host_is_dir(const char *path)
{
    DWORD attr = GetFileAttributesA(path);
    return attr != INVALID_FILE_ATTRIBUTES && (attr & FILE_ATTRIBUTE_DIRECTORY) != 0;
}

static int host_join(char *dst, int cap, const char *dir, const char *rel)
{
    int n;
    int m;

    if (dst == NULL || cap < 4 || dir == NULL || rel == NULL)
        return 0;
    n = (int)strlen(dir);
    m = (int)strlen(rel);
    if (n <= 0 || n + 1 + m >= cap)
        return 0;
    memcpy(dst, dir, (size_t)n);
    if (dst[n - 1] != '\\')
        dst[n++] = '\\';
    memcpy(dst + n, rel, (size_t)m + 1);
    return 1;
}

/* Copy files that are not already in dst. Existing files stay as the user left them. */
static void host_copy_missing(const char *src, const char *dst, int depth)
{
    char wild[HOST_PATH];
    char from[HOST_PATH];
    char to[HOST_PATH];
    WIN32_FIND_DATAA fd;
    HANDLE h;
    int n;

    if (depth > 24 || src == NULL || dst == NULL)
        return;
    CreateDirectoryA(dst, NULL);
    n = snprintf(wild, sizeof wild, "%s\\*", src);
    if (n <= 0 || n >= (int)sizeof wild)
        return;
    h = FindFirstFileA(wild, &fd);
    if (h == INVALID_HANDLE_VALUE)
        return;
    do {
        if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0)
            continue;
        if (snprintf(from, sizeof from, "%s\\%s", src, fd.cFileName) >= (int)sizeof from)
            continue;
        if (snprintf(to, sizeof to, "%s\\%s", dst, fd.cFileName) >= (int)sizeof to)
            continue;
        if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0)
            host_copy_missing(from, to, depth + 1);
        else if (GetFileAttributesA(to) == INVALID_FILE_ATTRIBUTES)
            CopyFileA(from, to, TRUE);
    } while (FindNextFileA(h, &fd));
    FindClose(h);
}

static int host_has_marker(const char *dir)
{
    char marker[HOST_PATH];
    if (!host_join(marker, (int)sizeof marker, dir, "BigInteger\\big-int.fth"))
        return 0;
    return GetFileAttributesA(marker) != INVALID_FILE_ATTRIBUTES;
}

static int host_find_ship(char *out, int cap)
{
    char mod[HOST_PATH];
    char dir[HOST_PATH];
    char trial[HOST_PATH];
    int i;
    DWORD n;

    n = GetModuleFileNameA(NULL, mod, (DWORD)sizeof mod);
    if (n == 0 || n >= sizeof mod)
        return 0;
    for (i = (int)n - 1; i >= 0; i--) {
        if (mod[i] == '\\' || mod[i] == '/') {
            mod[i] = '\0';
            break;
        }
    }
    if (snprintf(dir, sizeof dir, "%s", mod) >= (int)sizeof dir)
        return 0;
    for (i = 0; i < 8; i++) {
        if (host_join(trial, (int)sizeof trial, dir, "Forth\\Resources\\Library") &&
            host_has_marker(trial)) {
            if ((int)strlen(trial) >= cap)
                return 0;
            memcpy(out, trial, strlen(trial) + 1);
            return 1;
        }
        if (host_join(trial, (int)sizeof trial, dir, "Resources\\Library") &&
            host_has_marker(trial)) {
            if ((int)strlen(trial) >= cap)
                return 0;
            memcpy(out, trial, strlen(trial) + 1);
            return 1;
        }
        if (host_join(trial, (int)sizeof trial, dir, "EditForth\\Forth\\Resources\\Library") &&
            host_has_marker(trial)) {
            if ((int)strlen(trial) >= cap)
                return 0;
            memcpy(out, trial, strlen(trial) + 1);
            return 1;
        }
        for (n = (DWORD)strlen(dir); n > 0; n--) {
            if (dir[n - 1] == '\\' || dir[n - 1] == '/') {
                dir[n - 1] = '\0';
                break;
            }
        }
        if (n == 0)
            break;
    }
    return 0;
}

static void host_install_user_tree(void)
{
    char *home = NULL;
    char ship_lib[HOST_PATH];
    char ship_root[HOST_PATH];
    char src[HOST_PATH];
    char dst[HOST_PATH];
    const char *names[] = {"Library", "AutoLoad", "Docs"};
    size_t home_len = 0;
    int i;
    int slash;

    if (_dupenv_s(&home, &home_len, "USERPROFILE") != 0 || home == NULL || home[0] == '\0') {
        free(home);
        return;
    }
    if (snprintf(user_root, sizeof user_root, "%s\\Documents\\EditForthWin", home) >=
        (int)sizeof user_root) {
        free(home);
        return;
    }
    free(home);
    CreateDirectoryA(user_root, NULL);
    if (snprintf(library_root, sizeof library_root, "%s\\Library", user_root) >=
        (int)sizeof library_root)
        library_root[0] = '\0';
    if (!host_find_ship(ship_lib, (int)sizeof ship_lib)) {
        if (!host_has_marker(library_root))
            host_outs("Library source was not found. Documents\\EditForthWin has no Library yet.\n");
        if (snprintf(dst, sizeof dst, "%s\\Config", user_root) < (int)sizeof dst)
            CreateDirectoryA(dst, NULL);
        SetCurrentDirectoryA(user_root);
        return;
    }
    slash = (int)strlen(ship_lib);
    while (slash > 0 && ship_lib[slash - 1] != '\\')
        slash--;
    if (slash <= 1) {
        SetCurrentDirectoryA(user_root);
        return;
    }
    memcpy(ship_root, ship_lib, (size_t)slash - 1);
    ship_root[slash - 1] = '\0';
    for (i = 0; i < 3; i++) {
        if (!host_join(src, (int)sizeof src, ship_root, names[i]))
            continue;
        if (!host_is_dir(src))
            continue;
        if (!host_join(dst, (int)sizeof dst, user_root, names[i]))
            continue;
        host_copy_missing(src, dst, 0);
    }
    if (snprintf(dst, sizeof dst, "%s\\Config", user_root) < (int)sizeof dst)
        CreateDirectoryA(dst, NULL);
    if (host_has_marker(library_root))
        host_outs("EditForthWin folder: Documents\\EditForthWin\n");
    SetCurrentDirectoryA(user_root);
}

void host_fromlib(void)
{
    fromlib_armed = 1;
}

void host_fromlib_off(void)
{
    fromlib_armed = 0;
}

long long host_fromlib_query(void)
{
    return fromlib_armed ? -1 : 0;
}

static void (*host_cls_fn)(void);

void host_set_cls(void (*fn)(void))
{
    host_cls_fn = fn;
}

void host_cls(void)
{
    if (host_cls_fn != NULL)
        host_cls_fn();
}

long long host_library_path(char *dst, long long cap)
{
    size_t n;

    if (dst == NULL || cap < 2)
        return 0;
    n = strlen(library_root);
    if (n >= (size_t)cap)
        n = (size_t)cap - 1;
    if (n > 0)
        memcpy(dst, library_root, n);
    dst[n] = '\0';
    return (long long)n;
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
    host_slashes(tmp);
    src = tmp;
    if (!host_abs(tmp, (long long)strlen(tmp)) && fromlib_armed) {
        fromlib_armed = 0;
        if (library_root[0] == '\0' || !host_is_dir(library_root) ||
            !host_join(joined, (int)sizeof joined, library_root, tmp)) {
            host_outs("FROMLIB: Documents\\EditForthWin\\Library is missing\n");
            return 0;
        }
        src = joined;
    } else if (!host_abs(tmp, (long long)strlen(tmp)) && load_n > 0 && load_len[load_n - 1] > 0) {
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
    host_slashes(load_dir[load_n]);
    len = (int)strlen(load_dir[load_n]);
    load_len[load_n] = len;
    load_prev[load_n][0] = '\0';
    GetCurrentDirectoryA((DWORD)sizeof load_prev[load_n], load_prev[load_n]);
    load_n++;
    if (len > 0)
        SetCurrentDirectoryA(load_dir[load_n - 1]);
}

void host_end_load(void)
{
    if (load_n <= 0)
        return;
    load_n--;
    if (load_prev[load_n][0] != '\0')
        SetCurrentDirectoryA(load_prev[load_n]);
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
        host_outs("Included:\n  (none)\n");
        return;
    }
    host_outs("Included:\n");
    for (int i = 0; i < reg_n; i++) {
        host_outs("  ");
        host_out(reg_path[i], (size_t)reg_len[i]);
        host_outs("\n");
    }
}

static void emit_c(int c)
{
    unsigned char b = (unsigned char)c;
    host_out(&b, 1);
}

static int key_c(void)
{
    if (key_hook != NULL)
        return key_hook();
    return -1;
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
    host_out(buf, strlen(buf));
    host_outs("\n");
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
        host_out(fd.cFileName, strlen(fd.cFileName));
        host_outs("\n");
    } while (FindNextFileA(h, &fd));
    FindClose(h);
}

long long host_accept(char *buf, long long n)
{
    long long i = 0;
    int c;

    if (buf == NULL || n <= 0)
        return 0;
    while (i < n) {
        c = key_c();
        if (c < 0 || c == '\n')
            break;
        if (c == '\r')
            continue;
        buf[i++] = (char)c;
    }
    return i;
}

int forth_eval(const char *text, size_t n)
{
    return kernel_eval(text, n);
}

void forth_prompt(void)
{
    char buf[64];
    int n = snprintf(buf, sizeof buf, "ok(%lld)> ", forth_depth());
    if (n > 0)
        host_out(buf, (size_t)n);
}

int host_bi_selftest(void);

int forth_boot(void)
{
    kernel_set_emit(emit_c);
    kernel_set_key(key_c);
    if (kernel_init() != 0) {
        host_outs("kernel_init failed\n");
        return 1;
    }
    host_outs("=== EditForthWin 1.1.0 === Oct 15, 2026 6:05 PM ===\n");
    host_install_user_tree();
    host_bi_selftest();
    return 0;
}

/* One kernel_eval of the whole file. kernel1.fth defines words across lines. */
int forth_eval_file(const char *path)
{
    FILE *fp = NULL;
    long sz;
    char *buf;
    size_t nread;
    int rc;
    char msg[HOST_PATH + 64];

    if (fopen_s(&fp, path, "rb") != 0 || fp == NULL) {
        snprintf(msg, sizeof msg, "cannot open %s\n", path);
        host_outs(msg);
        return -1;
    }
    if (fseek(fp, 0, SEEK_END) != 0) {
        fclose(fp);
        snprintf(msg, sizeof msg, "cannot size %s\n", path);
        host_outs(msg);
        return -1;
    }
    sz = ftell(fp);
    if (sz < 0) {
        fclose(fp);
        snprintf(msg, sizeof msg, "cannot size %s\n", path);
        host_outs(msg);
        return -1;
    }
    if (fseek(fp, 0, SEEK_SET) != 0) {
        fclose(fp);
        snprintf(msg, sizeof msg, "cannot read %s\n", path);
        host_outs(msg);
        return -1;
    }
    buf = (char *)malloc((size_t)sz + 1);
    if (buf == NULL) {
        fclose(fp);
        host_outs("out of memory\n");
        return -1;
    }
    nread = fread(buf, 1, (size_t)sz, fp);
    fclose(fp);
    buf[nread] = '\0';
    rc = forth_eval(buf, nread);
    free(buf);
    return rc;
}
