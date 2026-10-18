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
static char *host_mem[HOST_FILES];
static long long host_mem_len[HOST_FILES];
static long long host_mem_pos[HOST_FILES];
static char load_dir[HOST_LOADS][HOST_PATH];
static char load_prev[HOST_LOADS][HOST_PATH];
static int load_len[HOST_LOADS];
static int load_n;
static int fromlib_armed;
static void (*host_edit_fn)(const char *path, int kind);
static void (*host_edit_at_fn)(const char *path, long long line);
static char user_root[HOST_PATH];
static char library_root[HOST_PATH];
static char reg_path[HOST_REGS][256];
static int reg_len[HOST_REGS];
static int reg_n;
static char last_path[256];
static int last_len;

static void host_slashes(char *s);

/* ~ and ~/name expand to USERPROFILE. ~someone is left unchanged. */
static int host_expand_home(char *dst, size_t cap, const char *src)
{
    char *home = NULL;
    size_t home_n = 0;
    size_t rest_n;
    const char *rest;
    int sep;

    if (src == NULL)
        return 0;
    if (src[0] != '~') {
        rest_n = strlen(src);
        if (rest_n >= cap)
            return 0;
        memcpy(dst, src, rest_n + 1);
        return 1;
    }
    rest = src + 1;
    if (*rest == '/' || *rest == '\\')
        rest++;
    else if (*rest != '\0') {
        rest_n = strlen(src);
        if (rest_n >= cap)
            return 0;
        memcpy(dst, src, rest_n + 1);
        return 1;
    }
    if (_dupenv_s(&home, &home_n, "USERPROFILE") != 0 || home == NULL || home[0] == '\0') {
        free(home);
        return 0;
    }
    home_n = strlen(home);
    rest_n = strlen(rest);
    sep = (rest_n > 0 && home[home_n - 1] != '\\' && home[home_n - 1] != '/') ? 1 : 0;
    if (home_n + (size_t)sep + rest_n >= cap) {
        free(home);
        return 0;
    }
    memcpy(dst, home, home_n);
    if (sep)
        dst[home_n++] = '\\';
    memcpy(dst + home_n, rest, rest_n + 1);
    free(home);
    return 1;
}

static int host_copy_path(const char *p, long long n, char *dst, size_t cap)
{
    char raw[HOST_PATH];
    char expanded[HOST_PATH];
    size_t nout;

    if (p == NULL || n <= 0 || (unsigned long long)n >= sizeof raw || dst == NULL)
        return 0;
    memcpy(raw, p, (size_t)n);
    raw[n] = '\0';
    if (!host_expand_home(expanded, sizeof expanded, raw))
        return 0;
    host_slashes(expanded);
    nout = strlen(expanded);
    if (nout >= cap)
        return 0;
    memcpy(dst, expanded, nout + 1);
    return 1;
}

static void host_mkdir_parents(const char *path)
{
    char buf[HOST_PATH];
    char *p;
    size_t n;

    if (path == NULL)
        return;
    n = strlen(path);
    if (n == 0 || n >= sizeof buf)
        return;
    memcpy(buf, path, n + 1);
    p = buf;
    if (p[0] == '\\' && p[1] == '\\') {
        p += 2;
        p = strchr(p, '\\');
        if (p == NULL)
            return;
        p++;
        p = strchr(p, '\\');
        if (p == NULL)
            return;
        p++;
    } else if (((p[0] >= 'A' && p[0] <= 'Z') || (p[0] >= 'a' && p[0] <= 'z')) && p[1] == ':') {
        p += 2;
        if (*p == '\\')
            p++;
    }
    for (; *p != '\0'; p++) {
        if (*p != '\\')
            continue;
        *p = '\0';
        if (buf[0] != '\0')
            CreateDirectoryA(buf, NULL);
        *p = '\\';
    }
}

static int host_slot(void)
{
    for (int i = 1; i < HOST_FILES; i++) {
        if (host_fp[i] == NULL && host_mem[i] == NULL)
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
    if (n >= 1 && (s[0] == '\\' || s[0] == '/' || s[0] == '~'))
        return 1;
    if (n >= 2 && s[1] == ':' &&
        ((s[0] >= 'A' && s[0] <= 'Z') || (s[0] >= 'a' && s[0] <= 'z')))
        return 1;
    return 0;
}

/* Virtual Config/HYPER.SPECS. The Mac host expands HYPER.CFG the same way.
   Forth OPEN-FILE never sees a disk file; READ-LINE walks the generated list. */

typedef struct HostList {
    char **v;
    int n;
    int cap;
} HostList;

static void host_list_free(HostList *list)
{
    int i;

    if (list == NULL)
        return;
    for (i = 0; i < list->n; i++)
        free(list->v[i]);
    free(list->v);
    list->v = NULL;
    list->n = 0;
    list->cap = 0;
}

static int host_list_add(HostList *list, const char *s)
{
    char *copy;
    char **grown;
    int cap;

    if (list == NULL || s == NULL)
        return 0;
    if (list->n >= list->cap) {
        cap = list->cap == 0 ? 64 : list->cap * 2;
        grown = (char **)realloc(list->v, (size_t)cap * sizeof(char *));
        if (grown == NULL)
            return 0;
        list->v = grown;
        list->cap = cap;
    }
    copy = _strdup(s);
    if (copy == NULL)
        return 0;
    list->v[list->n++] = copy;
    return 1;
}

static int host_list_has_ci(const HostList *list, const char *s)
{
    int i;

    for (i = 0; i < list->n; i++) {
        if (_stricmp(list->v[i], s) == 0)
            return 1;
    }
    return 0;
}

static int host_contains_ci(const char *hay, const char *needle)
{
    size_t nlen;

    if (hay == NULL || needle == NULL || needle[0] == '\0')
        return 0;
    nlen = strlen(needle);
    for (; *hay != '\0'; hay++) {
        if (_strnicmp(hay, needle, nlen) == 0)
            return 1;
    }
    return 0;
}

static int host_prefix_ci(const char *s, const char *prefix)
{
    size_t n;

    if (s == NULL || prefix == NULL)
        return 0;
    n = strlen(prefix);
    return _strnicmp(s, prefix, n) == 0;
}

static int host_suffix_ci(const char *s, const char *suffix)
{
    size_t ns;
    size_t nsu;

    if (s == NULL || suffix == NULL)
        return 0;
    ns = strlen(s);
    nsu = strlen(suffix);
    if (nsu > ns)
        return 0;
    return _stricmp(s + (ns - nsu), suffix) == 0;
}

static int host_path_cmp(const void *a, const void *b)
{
    const char *sa = *(const char *const *)a;
    const char *sb = *(const char *const *)b;
    return _stricmp(sa, sb);
}

static int host_library_dir(char *dst, size_t cap)
{
    int n;

    if (library_root[0] != '\0') {
        n = snprintf(dst, cap, "%s", library_root);
        return n > 0 && (size_t)n < cap;
    }
    if (user_root[0] != '\0') {
        n = snprintf(dst, cap, "%s\\Library", user_root);
        return n > 0 && (size_t)n < cap;
    }
    n = snprintf(dst, cap, "Library");
    return n > 0 && (size_t)n < cap;
}

static int host_user_dir(char *dst, size_t cap)
{
    int n;
    DWORD got;

    if (user_root[0] != '\0') {
        n = snprintf(dst, cap, "%s", user_root);
        return n > 0 && (size_t)n < cap;
    }
    got = GetCurrentDirectoryA((DWORD)cap, dst);
    return got > 0 && got < cap;
}

static int host_under_root(const char *full, const char *root, const char **rest)
{
    size_t n;

    if (full == NULL || root == NULL || root[0] == '\0')
        return 0;
    n = strlen(root);
    if (_strnicmp(full, root, n) != 0)
        return 0;
    if (full[n] == '\\' || full[n] == '/') {
        *rest = full + n + 1;
        return 1;
    }
    if (full[n] == '\0') {
        *rest = full + n;
        return 1;
    }
    return 0;
}

/* Disk path to the NDX key Forth will OPEN-FILE (Library/…, forward slashes). */
static int host_to_ndx(const char *full, char *ndx, size_t cap)
{
    char lib[HOST_PATH];
    char user[HOST_PATH];
    char tmp[HOST_PATH];
    const char *rest = NULL;
    const char *prefix = "";
    char *p;
    int n;

    if (!host_library_dir(lib, sizeof lib) || !host_user_dir(user, sizeof user))
        return 0;
    if (host_under_root(full, lib, &rest))
        prefix = "Library/";
    else if (host_under_root(full, user, &rest))
        prefix = "";
    else
        return 0;
    if (rest == NULL)
        return 0;
    n = snprintf(tmp, sizeof tmp, "%s%s", prefix, rest);
    if (n <= 0 || (size_t)n >= sizeof tmp || (size_t)n >= cap)
        return 0;
    for (p = tmp; *p != '\0'; p++) {
        if (*p == '\\')
            *p = '/';
    }
    if (strchr(tmp, '/') == NULL)
        return 0;
    memcpy(ndx, tmp, (size_t)n + 1);
    return 1;
}

static int host_spec_disk(const char *spec, char *disk, size_t cap)
{
    char norm[HOST_PATH];
    char lib[HOST_PATH];
    char user[HOST_PATH];
    const char *rel;
    size_t i;
    size_t n;
    int out;

    n = strlen(spec);
    if (n == 0 || n >= sizeof norm)
        return 0;
    for (i = 0; i <= n; i++)
        norm[i] = (spec[i] == '/') ? '\\' : spec[i];
    if (!host_library_dir(lib, sizeof lib) || !host_user_dir(user, sizeof user))
        return 0;
    if (host_prefix_ci(norm, "Resources\\Library\\"))
        rel = norm + strlen("Resources\\Library\\");
    else if (host_prefix_ci(norm, "Library\\"))
        rel = norm + strlen("Library\\");
    else if (host_prefix_ci(norm, "Resources\\")) {
        rel = norm + strlen("Resources\\");
        out = snprintf(disk, cap, "%s\\%s", user, rel);
        return out > 0 && (size_t)out < cap;
    } else {
        rel = norm;
        out = snprintf(disk, cap, "%s\\%s", user, rel);
        return out > 0 && (size_t)out < cap;
    }
    out = snprintf(disk, cap, "%s\\%s", lib, rel);
    return out > 0 && (size_t)out < cap;
}

static const char *host_glob_ext(const char *spec)
{
    if (host_suffix_ci(spec, ".fth"))
        return ".fth";
    if (host_suffix_ci(spec, ".fs"))
        return ".fs";
    return NULL;
}

static void host_walk_files(const char *dir, const char *ext, HostList *out, int depth)
{
    char wild[HOST_PATH];
    char child[HOST_PATH];
    WIN32_FIND_DATAA fd;
    HANDLE h;
    int n;

    if (dir == NULL || dir[0] == '\0' || depth > 32)
        return;
    n = snprintf(wild, sizeof wild, "%s\\*", dir);
    if (n <= 0 || n >= (int)sizeof wild)
        return;
    h = FindFirstFileA(wild, &fd);
    if (h == INVALID_HANDLE_VALUE)
        return;
    do {
        if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0)
            continue;
        if ((fd.dwFileAttributes & FILE_ATTRIBUTE_HIDDEN) != 0)
            continue;
        n = snprintf(child, sizeof child, "%s\\%s", dir, fd.cFileName);
        if (n <= 0 || n >= (int)sizeof child)
            continue;
        if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0)
            host_walk_files(child, ext, out, depth + 1);
        else if (ext == NULL || host_suffix_ci(fd.cFileName, ext))
            host_list_add(out, child);
    } while (FindNextFileA(h, &fd));
    FindClose(h);
}

static void host_expand_spec(const char *spec, HostList *batch)
{
    char disk[HOST_PATH];
    char lib[HOST_PATH];
    char user[HOST_PATH];
    DWORD attr;

    if (spec == NULL || spec[0] == '\0')
        return;
    if (strchr(spec, '*') == NULL && strchr(spec, '?') == NULL) {
        if (!host_spec_disk(spec, disk, sizeof disk))
            return;
        attr = GetFileAttributesA(disk);
        if (attr == INVALID_FILE_ATTRIBUTES)
            return;
        if ((attr & FILE_ATTRIBUTE_DIRECTORY) != 0)
            return;
        host_list_add(batch, disk);
        return;
    }
    if (!host_library_dir(lib, sizeof lib) || !host_user_dir(user, sizeof user))
        return;
    if (host_prefix_ci(spec, "Resources/Library/") || host_prefix_ci(spec, "Library/"))
        host_walk_files(lib, host_glob_ext(spec), batch, 0);
    else
        host_walk_files(user, host_glob_ext(spec), batch, 0);
}

static void host_trim_span(const char *s, size_t n, char *dst, size_t cap)
{
    while (n > 0 && (s[0] == ' ' || s[0] == '\t' || s[0] == '\r')) {
        s++;
        n--;
    }
    while (n > 0 && (s[n - 1] == ' ' || s[n - 1] == '\t' || s[n - 1] == '\r'))
        n--;
    if (n >= cap)
        n = cap - 1;
    memcpy(dst, s, n);
    dst[n] = '\0';
}

static void host_parse_hyper_cfg(const char *text, HostList *specs, HostList *excludes)
{
    const char *p;
    char line[HOST_PATH];
    char rest[HOST_PATH];

    if (text == NULL)
        return;
    p = text;
    while (*p != '\0') {
        const char *eol = p;
        size_t n;
        while (*eol != '\0' && *eol != '\n')
            eol++;
        n = (size_t)(eol - p);
        host_trim_span(p, n, line, sizeof line);
        p = (*eol == '\n') ? eol + 1 : eol;
        if (line[0] == '\0' || line[0] == '#')
            continue;
        if (strcmp(line, ";") == 0)
            break;
        if (host_prefix_ci(line, "*EXCLUDE")) {
            host_trim_span(line + 8, strlen(line + 8), rest, sizeof rest);
            if (rest[0] != '\0')
                host_list_add(excludes, rest);
            continue;
        }
        if (host_prefix_ci(line, "SPECS")) {
            host_trim_span(line + 5, strlen(line + 5), rest, sizeof rest);
            if (rest[0] != '\0')
                host_list_add(specs, rest);
        }
    }
}

static void host_hyper_defaults(HostList *specs, HostList *excludes)
{
    static const char *default_specs[] = {
        "Resources/Library/Sources/forth.s",
        "Resources/Library/Sources/boot_words.inc",
        "Resources/Library/Sources/boot_words_end.inc",
        "Resources/Library/Sources/colon_words.inc",
        "Resources/Library/Sources/kernel_api.h",
        "Resources/Library/**/*.fth",
        "Resources/Library/**/*.FTH",
    };
    static const char *default_excludes[] = {
        "Testing", "HayesTest", "ANSValidate", "DbgSpanSmoke",
        "Benchmarks", "HYPER.NDX",
    };
    int i;

    if (specs->n == 0) {
        for (i = 0; i < (int)(sizeof default_specs / sizeof default_specs[0]); i++)
            host_list_add(specs, default_specs[i]);
    }
    if (excludes->n == 0) {
        for (i = 0; i < (int)(sizeof default_excludes / sizeof default_excludes[0]); i++)
            host_list_add(excludes, default_excludes[i]);
    }
}

static char *host_read_file(const char *path)
{
    FILE *fp = NULL;
    char *buf;
    long sz;

    if (fopen_s(&fp, path, "rb") != 0 || fp == NULL)
        return NULL;
    if (fseek(fp, 0, SEEK_END) != 0) {
        fclose(fp);
        return NULL;
    }
    sz = ftell(fp);
    if (sz < 0 || sz > 1024 * 1024) {
        fclose(fp);
        return NULL;
    }
    if (fseek(fp, 0, SEEK_SET) != 0) {
        fclose(fp);
        return NULL;
    }
    buf = (char *)malloc((size_t)sz + 1);
    if (buf == NULL) {
        fclose(fp);
        return NULL;
    }
    if (sz > 0 && fread(buf, 1, (size_t)sz, fp) != (size_t)sz) {
        free(buf);
        fclose(fp);
        return NULL;
    }
    buf[sz] = '\0';
    fclose(fp);
    return buf;
}

static int host_excluded(const char *ndx, const char *full, const HostList *excludes)
{
    int i;

    for (i = 0; i < excludes->n; i++) {
        if (host_contains_ci(ndx, excludes->v[i]) || host_contains_ci(full, excludes->v[i]))
            return 1;
    }
    return 0;
}

/* Generated list, or NULL so OPEN-FILE fails and Forth uses its fallback.
   The bytes stay in the file slot. A Windows tmpfile was still at EOF when
   READ-LINE ran, so the indexer treated the list as empty. */
static char *host_hyper_specs_text(long long *out_len)
{
    char cfg_path[HOST_PATH];
    char user[HOST_PATH];
    char *cfg = NULL;
    char *text = NULL;
    char ndx[HOST_PATH];
    HostList specs;
    HostList excludes;
    HostList seen;
    size_t total;
    size_t used;
    int i;
    int n;

    memset(&specs, 0, sizeof specs);
    memset(&excludes, 0, sizeof excludes);
    memset(&seen, 0, sizeof seen);
    if (host_user_dir(user, sizeof user)) {
        n = snprintf(cfg_path, sizeof cfg_path, "%s\\Config\\HYPER.CFG", user);
        if (n > 0 && (size_t)n < sizeof cfg_path)
            cfg = host_read_file(cfg_path);
    }
    host_parse_hyper_cfg(cfg, &specs, &excludes);
    free(cfg);
    host_hyper_defaults(&specs, &excludes);

    for (i = 0; i < specs.n; i++) {
        HostList batch;
        int j;

        memset(&batch, 0, sizeof batch);
        host_expand_spec(specs.v[i], &batch);
        if (batch.n > 1)
            qsort(batch.v, (size_t)batch.n, sizeof(char *), host_path_cmp);
        for (j = 0; j < batch.n; j++) {
            if (!host_to_ndx(batch.v[j], ndx, sizeof ndx))
                continue;
            if (host_excluded(ndx, batch.v[j], &excludes))
                continue;
            if (host_list_has_ci(&seen, ndx))
                continue;
            host_list_add(&seen, ndx);
        }
        host_list_free(&batch);
    }
    host_list_free(&specs);
    host_list_free(&excludes);

    total = 1;
    for (i = 0; i < seen.n; i++)
        total += strlen(seen.v[i]) + 1;
    if (seen.n == 0)
        total = 2;
    text = (char *)malloc(total);
    if (text == NULL) {
        host_list_free(&seen);
        return NULL;
    }
    if (seen.n == 0) {
        text[0] = '\n';
        text[1] = '\0';
        *out_len = 1;
        host_list_free(&seen);
        return text;
    }
    used = 0;
    for (i = 0; i < seen.n; i++) {
        size_t len = strlen(seen.v[i]);
        memcpy(text + used, seen.v[i], len);
        used += len;
        text[used++] = '\n';
    }
    text[used] = '\0';
    *out_len = (long long)used;
    host_list_free(&seen);
    return text;
}

static int host_is_hyper_specs(const char *path)
{
    const char *base;
    const char *end;
    size_t n;

    if (path == NULL)
        return 0;
    end = path + strlen(path);
    while (end > path && (end[-1] == ' ' || end[-1] == '\t' ||
                          end[-1] == '\\' || end[-1] == '/'))
        end--;
    base = path;
    for (const char *p = path; p < end; p++) {
        if (*p == '\\' || *p == '/')
            base = p + 1;
    }
    n = (size_t)(end - base);
    return n == 11 && _strnicmp(base, "HYPER.SPECS", 11) == 0;
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
    if (host_is_hyper_specs(path)) {
        long long len = 0;
        char *text = host_hyper_specs_text(&len);
        if (text == NULL)
            return 0;
        host_mem[slot] = text;
        host_mem_len[slot] = len;
        host_mem_pos[slot] = 0;
        return slot;
    }
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
    host_mkdir_parents(path);
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
    FILE *fp;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        free(host_mem[id]);
        host_mem[id] = NULL;
        host_mem_len[id] = 0;
        host_mem_pos[id] = 0;
        return 0;
    }
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    host_fp[id] = NULL;
    return fclose(fp) == 0 ? 0 : -1;
}

long long host_read(char *buf, long long n, long long id)
{
    FILE *fp;
    size_t got;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        long long left;
        long long take;
        if (buf == NULL || n < 0)
            return -1;
        if (n == 0 || host_mem_pos[id] >= host_mem_len[id])
            return 0;
        left = host_mem_len[id] - host_mem_pos[id];
        take = n < left ? n : left;
        memcpy(buf, host_mem[id] + host_mem_pos[id], (size_t)take);
        host_mem_pos[id] += take;
        return take;
    }
    fp = host_lookup(id);
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
    FILE *fp;
    __int64 pos;
    __int64 sz;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL)
        return host_mem_len[id];
    fp = host_lookup(id);
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
    FILE *fp;

    if (hi != 0)
        return -1;
    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        if (lo < 0)
            return -1;
        host_mem_pos[id] = lo > host_mem_len[id] ? host_mem_len[id] : lo;
        return 0;
    }
    fp = host_lookup(id);
    if (fp == NULL)
        return -1;
    if (_fseeki64(fp, (__int64)lo, SEEK_SET) != 0)
        return -1;
    return 0;
}

long long host_flush(long long id)
{
    FILE *fp;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL)
        return 0;
    fp = host_lookup(id);
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

/* Copy src onto dst. overwrite 0 leaves files the user already has. */
static void host_copy_tree(const char *src, const char *dst, int overwrite, int depth)
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
            host_copy_tree(from, to, overwrite, depth + 1);
        else if (overwrite || GetFileAttributesA(to) == INVALID_FILE_ATTRIBUTES)
            CopyFileA(from, to, overwrite ? FALSE : TRUE);
    } while (FindNextFileA(h, &fd));
    FindClose(h);
}

static void host_copy_missing(const char *src, const char *dst, int depth)
{
    host_copy_tree(src, dst, 0, depth);
}

static void host_remove_tree(const char *dir)
{
    char wild[HOST_PATH];
    char child[HOST_PATH];
    WIN32_FIND_DATAA fd;
    HANDLE h;
    int n;

    if (dir == NULL || dir[0] == '\0')
        return;
    n = snprintf(wild, sizeof wild, "%s\\*", dir);
    if (n <= 0 || n >= (int)sizeof wild)
        return;
    h = FindFirstFileA(wild, &fd);
    if (h != INVALID_HANDLE_VALUE) {
        do {
            if (strcmp(fd.cFileName, ".") == 0 || strcmp(fd.cFileName, "..") == 0)
                continue;
            if (snprintf(child, sizeof child, "%s\\%s", dir, fd.cFileName) >= (int)sizeof child)
                continue;
            if ((fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY) != 0)
                host_remove_tree(child);
            else
                DeleteFileA(child);
        } while (FindNextFileA(h, &fd));
        FindClose(h);
    }
    RemoveDirectoryA(dir);
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

/* mode 0: copy missing Library/AutoLoad/Docs.
   mode 1: replace those three folders from the ship tree. Config stays.
   mode 2: rename Documents\EditForthWin to EditForthWin.UserN, then copy fresh. */
void host_user_tree(int mode)
{
    char *home = NULL;
    char ship_lib[HOST_PATH];
    char ship_root[HOST_PATH];
    char src[HOST_PATH];
    char dst[HOST_PATH];
    char renamed[HOST_PATH];
    const char *names[] = {"Library", "AutoLoad", "Docs"};
    size_t home_len = 0;
    int i;
    int slash;
    int n;
    int overwrite;

    if (user_root[0] == '\0') {
        if (_dupenv_s(&home, &home_len, "USERPROFILE") != 0 || home == NULL || home[0] == '\0') {
            free(home);
            host_outs("? user folder: USERPROFILE is not set\n");
            return;
        }
        if (snprintf(user_root, sizeof user_root, "%s\\Documents\\EditForthWin", home) >=
            (int)sizeof user_root) {
            free(home);
            user_root[0] = '\0';
            host_outs("? user folder path is too long\n");
            return;
        }
        free(home);
    }
    if (!host_find_ship(ship_lib, (int)sizeof ship_lib)) {
        host_outs("? shipped Library was not found beside the Forth program\n");
        return;
    }
    slash = (int)strlen(ship_lib);
    while (slash > 0 && ship_lib[slash - 1] != '\\')
        slash--;
    if (slash <= 1) {
        host_outs("? shipped Library path is not usable\n");
        return;
    }
    memcpy(ship_root, ship_lib, (size_t)slash - 1);
    ship_root[slash - 1] = '\0';

    if (mode == 2) {
        SetCurrentDirectoryA("C:\\");
        for (n = 1; n < 100; n++) {
            if (snprintf(renamed, sizeof renamed, "%s.User%d", user_root, n) >= (int)sizeof renamed) {
                host_outs("? rename path is too long\n");
                SetCurrentDirectoryA(user_root);
                return;
            }
            if (GetFileAttributesA(renamed) == INVALID_FILE_ATTRIBUTES)
                break;
        }
        if (n >= 100) {
            host_outs("? too many EditForthWin.User folders\n");
            SetCurrentDirectoryA(user_root);
            return;
        }
        if (!MoveFileA(user_root, renamed)) {
            host_outs("? could not rename Documents\\EditForthWin\n");
            SetCurrentDirectoryA(user_root);
            return;
        }
        CreateDirectoryA(user_root, NULL);
        host_outs("Renamed Documents\\EditForthWin\n");
    } else if (mode == 1) {
        for (i = 0; i < 3; i++) {
            if (!host_join(dst, (int)sizeof dst, user_root, names[i]))
                continue;
            host_remove_tree(dst);
        }
        host_outs("Replacing Library, AutoLoad, and Docs\n");
    }

    overwrite = mode == 0 ? 0 : 1;
    for (i = 0; i < 3; i++) {
        if (!host_join(src, (int)sizeof src, ship_root, names[i]))
            continue;
        if (!host_is_dir(src))
            continue;
        if (!host_join(dst, (int)sizeof dst, user_root, names[i]))
            continue;
        host_copy_tree(src, dst, overwrite, 0);
    }
    if (snprintf(dst, sizeof dst, "%s\\Config", user_root) < (int)sizeof dst)
        CreateDirectoryA(dst, NULL);
    if (snprintf(library_root, sizeof library_root, "%s\\Library", user_root) >= (int)sizeof library_root)
        library_root[0] = '\0';
    if (mode == 0)
        host_outs("Updated missing files in Documents\\EditForthWin\n");
    else
        host_outs("Restored shipped files in Documents\\EditForthWin\n");
    if (mode == 2)
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
    if (!host_expand_home(joined, sizeof joined, tmp))
        return 0;
    memcpy(tmp, joined, strlen(joined) + 1);
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

void host_set_edit(void (*fn)(const char *path, int kind))
{
    host_edit_fn = fn;
}

static int host_is_file(const char *path)
{
    DWORD attr = GetFileAttributesA(path);

    return attr != INVALID_FILE_ATTRIBUTES && (attr & FILE_ATTRIBUTE_DIRECTORY) == 0;
}

/* kind 0 opens a file. kind 1 asks the editor for a dialog at path (empty = cwd). */
void host_edit(const char *p, long long n)
{
    int armed = fromlib_armed;
    char resolved[HOST_PATH];
    char alt[HOST_PATH];
    long long rn;
    const char *leaf;
    char *slash;

    if (p == NULL || n <= 0) {
        if (armed)
            fromlib_armed = 0;
        if (armed && library_root[0] != '\0' && host_is_dir(library_root)) {
            if (host_edit_fn != NULL)
                host_edit_fn(library_root, 1);
            else
                host_outs("EDIT: choose a file in the editor\n");
            return;
        }
        if (armed) {
            host_outs("FROMLIB: Documents\\EditForthWin\\Library is missing\n");
            return;
        }
        if (host_edit_fn != NULL)
            host_edit_fn("", 1);
        else
            host_outs("EDIT: choose a file in the editor\n");
        return;
    }
    rn = host_resolve(p, n, resolved, (long long)sizeof resolved);
    if (rn <= 0) {
        host_outs("can't edit: ");
        host_out(p, (size_t)n);
        host_outs(" (not found)\n");
        return;
    }
    if (!host_is_file(resolved)) {
        leaf = strrchr(resolved, '\\');
        leaf = leaf != NULL ? leaf + 1 : resolved;
        if (strchr(leaf, '.') == NULL && (size_t)rn + 5 < sizeof alt) {
            memcpy(alt, resolved, (size_t)rn);
            memcpy(alt + rn, ".fth", 5);
            if (host_is_file(alt)) {
                memcpy(resolved, alt, strlen(alt) + 1);
                rn = (long long)strlen(resolved);
            }
        }
    }
    if (!host_is_file(resolved)) {
        host_outs("can't edit: ");
        host_outs(resolved);
        host_outs(" (not found)\n");
        return;
    }
    if (!armed) {
        slash = strrchr(resolved, '\\');
        if (slash != NULL && slash != resolved) {
            *slash = '\0';
            SetCurrentDirectoryA(resolved);
            *slash = '\\';
        }
    }
    if (host_edit_fn != NULL)
        host_edit_fn(resolved, 0);
    host_outs("EDIT: ");
    host_outs(resolved);
    host_outs("\n");
}

void host_set_edit_at(void (*fn)(const char *path, long long line))
{
    host_edit_at_fn = fn;
}

/* Open a resolved path at a 1-based line. Line 0 opens only. No cwd change
   and no file dialog. With no editor connected this validates and returns. */
void host_edit_at(const char *p, long long n, long long line)
{
    char resolved[HOST_PATH];
    const char *s;
    long long rn;
    long long a;
    long long b;

    if (line < 0)
        line = 0;
    if (p == NULL || n <= 0) {
        host_outs("? EDIT-AT needs a path\n");
        return;
    }
    a = 0;
    b = n;
    while (a < b) {
        char c = p[a];
        if (c != ' ' && c != '\t' && c != '\r' && c != '\n')
            break;
        a++;
    }
    while (b > a) {
        char c = p[b - 1];
        if (c != ' ' && c != '\t' && c != '\r' && c != '\n')
            break;
        b--;
    }
    if (b <= a) {
        host_outs("? EDIT-AT needs a path\n");
        return;
    }
    s = p + a;
    rn = host_resolve(s, b - a, resolved, (long long)sizeof resolved);
    if (rn <= 0 || !host_is_file(resolved)) {
        host_outs("can't edit: ");
        if (rn > 0)
            host_outs(resolved);
        else
            host_out(s, (size_t)(b - a));
        host_outs(" (not found)\n");
        return;
    }
    if (host_edit_at_fn != NULL)
        host_edit_at_fn(resolved, line);
}

static void drain_handle(HANDLE h)
{
    char buf[1024];
    DWORD avail;
    DWORD got;

    if (h == NULL || h == INVALID_HANDLE_VALUE)
        return;
    for (;;) {
        avail = 0;
        if (!PeekNamedPipe(h, NULL, 0, NULL, &avail, NULL) || avail == 0)
            return;
        if (avail > sizeof buf)
            avail = (DWORD)sizeof buf;
        got = 0;
        if (!ReadFile(h, buf, avail, &got, NULL) || got == 0)
            return;
        host_out(buf, (size_t)got);
    }
}

/* SYSTEM ( c-addr u -- n ). Same job as Mac /bin/sh -c: run the string in
   the session directory and return the process exit code, or -1. */
long long host_system(const char *cmd, long long n)
{
    wchar_t comspec[MAX_PATH];
    wchar_t *wcmd = NULL;
    wchar_t *cline = NULL;
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    SECURITY_ATTRIBUTES sa;
    HANDLE out_r = NULL;
    HANDLE out_w = NULL;
    HANDLE err_r = NULL;
    HANDLE err_w = NULL;
    HANDLE nul = NULL;
    DWORD code = 0;
    DWORD com_n;
    int wn;
    int start;
    int end;
    size_t cn;
    long long rc = -1;

    if (cmd == NULL || n <= 0) {
        host_outs("SYSTEM: empty command\n");
        return -1;
    }
    if (n > 8192) {
        host_outs("SYSTEM: command is too long\n");
        return -1;
    }
    start = 0;
    end = (int)n;
    while (start < end && (cmd[start] == ' ' || cmd[start] == '\t' ||
                           cmd[start] == '\r' || cmd[start] == '\n'))
        start++;
    while (end > start && (cmd[end - 1] == ' ' || cmd[end - 1] == '\t' ||
                           cmd[end - 1] == '\r' || cmd[end - 1] == '\n'))
        end--;
    if (end <= start) {
        host_outs("SYSTEM: empty command\n");
        return -1;
    }
    wn = MultiByteToWideChar(CP_UTF8, 0, cmd + start, end - start, NULL, 0);
    if (wn <= 0) {
        host_outs("SYSTEM: failed to launch\n");
        return -1;
    }
    wcmd = (wchar_t *)malloc(((size_t)wn + 1) * sizeof(wchar_t));
    if (wcmd == NULL) {
        host_outs("SYSTEM: failed to launch\n");
        return -1;
    }
    MultiByteToWideChar(CP_UTF8, 0, cmd + start, end - start, wcmd, wn);
    wcmd[wn] = 0;
    com_n = GetEnvironmentVariableW(L"ComSpec", comspec, MAX_PATH);
    if (com_n == 0 || com_n >= MAX_PATH) {
        memcpy(comspec, L"cmd.exe", 8 * sizeof(wchar_t));
    }
    cn = wcslen(comspec) + (size_t)wn + 8;
    cline = (wchar_t *)malloc(cn * sizeof(wchar_t));
    if (cline == NULL) {
        host_outs("SYSTEM: failed to launch\n");
        free(wcmd);
        return -1;
    }
    _snwprintf_s(cline, cn, _TRUNCATE, L"\"%s\" /c %s", comspec, wcmd);
    memset(&sa, 0, sizeof sa);
    sa.nLength = sizeof sa;
    sa.bInheritHandle = TRUE;
    if (!CreatePipe(&out_r, &out_w, &sa, 0) || !CreatePipe(&err_r, &err_w, &sa, 0)) {
        host_outs("SYSTEM: failed to launch\n");
        goto done;
    }
    SetHandleInformation(out_r, HANDLE_FLAG_INHERIT, 0);
    SetHandleInformation(err_r, HANDLE_FLAG_INHERIT, 0);
    nul = CreateFileW(L"NUL", GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE,
                      &sa, OPEN_EXISTING, 0, NULL);
    if (nul == INVALID_HANDLE_VALUE) {
        nul = NULL;
        host_outs("SYSTEM: failed to launch\n");
        goto done;
    }
    memset(&si, 0, sizeof si);
    memset(&pi, 0, sizeof pi);
    si.cb = sizeof si;
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdInput = nul;
    si.hStdOutput = out_w;
    si.hStdError = err_w;
    if (!CreateProcessW(comspec, cline, NULL, NULL, TRUE, CREATE_NO_WINDOW,
                        NULL, NULL, &si, &pi)) {
        host_outs("SYSTEM: failed to launch\n");
        goto done;
    }
    CloseHandle(out_w);
    out_w = NULL;
    CloseHandle(err_w);
    err_w = NULL;
    for (;;) {
        drain_handle(out_r);
        drain_handle(err_r);
        if (WaitForSingleObject(pi.hProcess, 30) == WAIT_OBJECT_0) {
            drain_handle(out_r);
            drain_handle(err_r);
            break;
        }
    }
    if (GetExitCodeProcess(pi.hProcess, &code) && code != STILL_ACTIVE)
        rc = (long long)(int)code;
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    pi.hThread = NULL;
    pi.hProcess = NULL;
done:
    if (out_w != NULL)
        CloseHandle(out_w);
    if (err_w != NULL)
        CloseHandle(err_w);
    if (out_r != NULL)
        CloseHandle(out_r);
    if (err_r != NULL)
        CloseHandle(err_r);
    if (nul != NULL)
        CloseHandle(nul);
    free(wcmd);
    free(cline);
    return rc;
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

int host_facility_emit(unsigned char byte);
void host_facility_op(int64_t op, int64_t a, int64_t b);

long long host_read_line(char *buf, long long n, long long id, long long *flag);
long long host_write_line(const char *buf, long long n, long long id);
long long host_position(long long id);
long long host_resize_file(long long id, long long lo, long long hi);
long long host_delete(const char *p, long long n);
long long host_rename(const char *a, long long an, const char *b, long long bn);
long long host_file_status(const char *p, long long n, long long *attr);

/* Stand-alone (SA-FILES) calls this when the file hook cell is zero.
   op: 1 open 2 create 3 close 4 read 5 write 6 rline 7 wline
       8 pos 9 size 10 repos 11 resize 12 delete 13 rename 14 status 15 flush
   Returns ior (0 or -1). o1/o2/o3 are the extra results. */
long long sa_win_file_op(long long op, long long a, long long b, long long c,
                         long long d, void *ptr, long long *o1, long long *o2,
                         long long *o3)
{
    long long n;
    long long flag;

    if (o1 != NULL)
        *o1 = 0;
    if (o2 != NULL)
        *o2 = 0;
    if (o3 != NULL)
        *o3 = 0;
    switch ((int)op) {
    case 1:
    case 2:
        n = (op == 1) ? host_open(ptr, b, c) : host_create(ptr, b, c);
        if (n == 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 3:
        return host_close(a);
    case 4:
        n = host_read(ptr, b, a);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 5:
        return host_write(ptr, b, a);
    case 6:
        flag = 0;
        n = host_read_line(ptr, b, a, &flag);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        if (o2 != NULL)
            *o2 = flag;
        return 0;
    case 7:
        return host_write_line(ptr, b, a);
    case 8:
        n = host_position(a);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 9:
        n = host_size(a);
        if (n < 0)
            return -1;
        if (o1 != NULL)
            *o1 = n;
        return 0;
    case 10:
        return host_repos(a, b, c);
    case 11:
        return host_resize_file(a, b, c);
    case 12:
        return host_delete(ptr, b);
    case 13:
        return host_rename(ptr, b, (const char *)c, d);
    case 14:
        return host_file_status(ptr, b, o1);
    case 15:
        return host_flush(a);
    default:
        return -1;
    }
}

/* Stand-alone (SA-PRINT) calls this when the emit hook cell is zero. */
void sa_win_putchar(unsigned long long c)
{
    unsigned char b = (unsigned char)c;
    if (host_facility_emit(b))
        return;
    host_out(&b, 1);
}

static void emit_c(int c)
{
    sa_win_putchar((unsigned long long)(unsigned char)c);
}

static int key_c(void)
{
    if (key_hook != NULL)
        return key_hook();
    return -1;
}

long long host_read_line(char *buf, long long n, long long id, long long *flag)
{
    FILE *fp;
    long long i = 0;
    int c;

    if (flag != NULL)
        *flag = 0;
    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL) {
        long long pos = host_mem_pos[id];
        long long len = host_mem_len[id];
        const char *base = host_mem[id];
        if (n < 0 || (buf == NULL && n > 0))
            return -1;
        if (pos >= len)
            return 0;
        if (flag != NULL)
            *flag = -1;
        while (pos < len) {
            char ch = base[pos++];
            if (ch == '\n') {
                host_mem_pos[id] = pos;
                return i;
            }
            if (ch == '\r') {
                if (pos < len && base[pos] == '\n')
                    pos++;
                host_mem_pos[id] = pos;
                return i;
            }
            if (i >= n) {
                host_mem_pos[id] = pos - 1;
                return i;
            }
            if (buf != NULL)
                buf[i] = ch;
            i++;
        }
        host_mem_pos[id] = pos;
        return i;
    }
    fp = host_lookup(id);
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
    FILE *fp;
    __int64 pos;

    if (id >= 1 && id < HOST_FILES && host_mem[id] != NULL)
        return host_mem_pos[id];
    fp = host_lookup(id);
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
    kernel_set_facility_op(host_facility_op);
    if (kernel_init() != 0) {
        host_outs("kernel_init failed\n");
        return 1;
    }
    {
        char ban[192];
        int bn = snprintf(ban, sizeof ban, "=== EditForthWin %s === %s ===\n",
                          kernel_version, kernel_built);
        if (bn > 0)
            host_outs(ban);
    }
    host_install_user_tree();
    host_bi_selftest();
    return 0;
}

int forth_eval_file(const char *path);

static int autoload_enabled = 1;

void forth_autoload_set(int on)
{
    autoload_enabled = on ? 1 : 0;
}

/* Evaluate AutoLoad/autoload.fth as one buffer from Documents\EditForthWin.
   Relative Library/ names then resolve against that folder. INCLUDE would
   push AutoLoad\ and look for Library beside the script. */
void forth_autoload(void)
{
    char path[HOST_PATH];
    static const char main_line[] = "[DEFINED] MAIN [IF] MAIN [THEN]";
    int rc;

    if (!autoload_enabled || user_root[0] == '\0')
        return;
    if (snprintf(path, sizeof path, "%s\\AutoLoad\\autoload.fth", user_root) >= (int)sizeof path)
        return;
    if (GetFileAttributesA(path) == INVALID_FILE_ATTRIBUTES)
        return;
    SetCurrentDirectoryA(user_root);
    rc = forth_eval_file(path);
    if (rc != 0)
        host_outs("autoload did not finish\n");
    forth_eval(main_line, sizeof main_line - 1);
    SetCurrentDirectoryA(user_root);
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
