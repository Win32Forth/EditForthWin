/* Public domain.
   Background HYPER-REINDEX. The Forth word (HX-BG-REINDEX) calls
   host_hyper_reindex. A second forth*.exe --agent writes
   Config\HYPER.NDX.building. The live index is replaced only after that
   child prints HX-BUILD-OK and exits 0. The editor companion returns at
   once and reloads later. A standalone console waits, then returns 1 so
   Forth reloads before HYPER-REINDEX returns. */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <windows.h>

#define HYPER_PATH 1024
#define HYPER_SOURCES 4096
#define HYPER_CAPTURE 8192

int host_documents_dir(char *dst, size_t cap);
char *host_hyper_source_list(long long *out_len);
void host_outs(const char *s);

int companion_is_active(void);
int companion_is_ready(void);
void companion_status_note(const char *text);
int companion_eval_idle(const char *text);

static volatile LONG g_hyper_busy = 0;

static void hyper_note(const char *text)
{
    if (text == NULL)
        return;
    if (companion_is_active())
        companion_status_note(text);
    else
        host_outs(text);
}

static void hyper_console(const char *text)
{
    host_outs(text);
}

static int hyper_join(char *dst, int cap, const char *dir, const char *rel)
{
    int n;
    int i;

    if (rel != NULL && rel[0] != '\0' &&
        (rel[0] == '\\' || rel[0] == '/' ||
         (rel[1] == ':' &&
          ((rel[0] >= 'A' && rel[0] <= 'Z') || (rel[0] >= 'a' && rel[0] <= 'z'))))) {
        n = snprintf(dst, (size_t)cap, "%s", rel);
    } else {
        n = snprintf(dst, (size_t)cap, "%s\\%s", dir, rel != NULL ? rel : "");
    }
    if (n <= 0 || n >= cap)
        return 0;
    for (i = 0; dst[i] != '\0'; i++) {
        if (dst[i] == '/')
            dst[i] = '\\';
    }
    return 1;
}

static int hyper_mtime(const char *path, FILETIME *out, int *exists, long long *size)
{
    WIN32_FILE_ATTRIBUTE_DATA info;

    *exists = 0;
    *size = 0;
    memset(out, 0, sizeof *out);
    if (path == NULL || path[0] == '\0')
        return 0;
    if (!GetFileAttributesExA(path, GetFileExInfoStandard, &info))
        return 0;
    if (info.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
        return 0;
    *exists = 1;
    *out = info.ftLastWriteTime;
    *size = ((long long)info.nFileSizeHigh << 32) | info.nFileSizeLow;
    return 1;
}

static int hyper_same_path(const char *a, const char *b)
{
    int i;

    if (a == NULL || b == NULL)
        return 0;
    for (i = 0;; i++) {
        char ca = a[i];
        char cb = b[i];
        if (ca == '/')
            ca = '\\';
        if (cb == '/')
            cb = '\\';
        if (ca >= 'A' && ca <= 'Z')
            ca = (char)(ca - 'A' + 'a');
        if (cb >= 'A' && cb <= 'Z')
            cb = (char)(cb - 'A' + 'a');
        if (ca != cb)
            return 0;
        if (ca == '\0')
            return 1;
    }
}

static int hyper_has(char **list, int n, const char *path)
{
    int i;

    for (i = 0; i < n; i++) {
        if (hyper_same_path(list[i], path))
            return 1;
    }
    return 0;
}

static void hyper_free_list(char **list, int n)
{
    int i;

    for (i = 0; i < n; i++)
        free(list[i]);
}

static int hyper_split(char *text, char **list, int cap)
{
    int n = 0;
    char *p = text;

    if (text == NULL)
        return 0;
    while (*p != '\0' && n < cap) {
        char *end = p;
        int len;

        while (*end != '\0' && *end != '\n' && *end != '\r')
            end++;
        len = (int)(end - p);
        while (len > 0 && (p[len - 1] == ' ' || p[len - 1] == '\t'))
            len--;
        if (len > 0) {
            char *copy = (char *)malloc((size_t)len + 1);
            if (copy == NULL)
                break;
            memcpy(copy, p, (size_t)len);
            copy[len] = '\0';
            list[n++] = copy;
        }
        if (*end == '\r')
            end++;
        if (*end == '\n')
            end++;
        p = end;
    }
    return n;
}

static int hyper_index_paths(const char *index, char **list, int cap)
{
    FILE *fp = NULL;
    char line[HYPER_PATH];
    int n = 0;

    if (fopen_s(&fp, index, "rb") != 0 || fp == NULL)
        return 0;
    while (fgets(line, (int)sizeof line, fp) != NULL && n < cap) {
        char *s = line;
        int len;

        while (*s == ' ' || *s == '\t')
            s++;
        if (s[0] != '@' || s[1] != ' ')
            continue;
        s += 2;
        len = (int)strlen(s);
        while (len > 0 && (s[len - 1] == '\n' || s[len - 1] == '\r' ||
                           s[len - 1] == ' ' || s[len - 1] == '\t'))
            s[--len] = '\0';
        if (len <= 0)
            continue;
        list[n] = (char *)malloc((size_t)len + 1);
        if (list[n] == NULL)
            break;
        memcpy(list[n], s, (size_t)len + 1);
        n++;
    }
    fclose(fp);
    return n;
}

static int hyper_entry_count(const char *path)
{
    FILE *fp = NULL;
    char line[HYPER_PATH];
    int n = 0;

    if (fopen_s(&fp, path, "rb") != 0 || fp == NULL)
        return 0;
    while (fgets(line, (int)sizeof line, fp) != NULL) {
        char *s = line;
        while (*s == ' ' || *s == '\t')
            s++;
        if (*s == '\0' || *s == '\n' || *s == '\r' || *s == '#' || *s == '@')
            continue;
        n++;
    }
    fclose(fp);
    return n;
}

static int hyper_needs(const char *user, const char *index, char **sources, int nsrc)
{
    FILETIME index_time;
    FILETIME cfg_time;
    int exists = 0;
    long long size = 0;
    char cfg[HYPER_PATH];
    char **indexed;
    int nindexed;
    int i;

    if (!hyper_mtime(index, &index_time, &exists, &size) || !exists || size <= 0)
        return 1;
    if (hyper_join(cfg, (int)sizeof cfg, user, "Config\\HYPER.CFG") &&
        hyper_mtime(cfg, &cfg_time, &exists, &size) && exists &&
        CompareFileTime(&cfg_time, &index_time) > 0)
        return 1;
    for (i = 0; i < nsrc; i++) {
        char full[HYPER_PATH];
        FILETIME src_time;

        if (!hyper_join(full, (int)sizeof full, user, sources[i]))
            return 1;
        if (!hyper_mtime(full, &src_time, &exists, &size) || !exists)
            continue;
        if (CompareFileTime(&src_time, &index_time) > 0)
            return 1;
    }
    indexed = (char **)calloc((size_t)HYPER_SOURCES, sizeof(char *));
    if (indexed == NULL)
        return 1;
    nindexed = hyper_index_paths(index, indexed, HYPER_SOURCES);
    if (nindexed != nsrc) {
        hyper_free_list(indexed, nindexed);
        free(indexed);
        return 1;
    }
    for (i = 0; i < nsrc; i++) {
        if (!hyper_has(indexed, nindexed, sources[i])) {
            hyper_free_list(indexed, nindexed);
            free(indexed);
            return 1;
        }
    }
    hyper_free_list(indexed, nindexed);
    free(indexed);
    return 0;
}

typedef struct HyperCapture {
    HANDLE read;
    char buf[HYPER_CAPTURE];
    int n;
    int saw_ok;
} HyperCapture;

static DWORD WINAPI hyper_capture_read(LPVOID param)
{
    HyperCapture *cap = (HyperCapture *)param;
    char tmp[1024];
    char hold[9];
    int hold_n = 0;

    for (;;) {
        DWORD got = 0;
        char scan[9 + 1024];
        int total;
        if (!ReadFile(cap->read, tmp, sizeof tmp, &got, NULL) || got == 0)
            break;
        if (!cap->saw_ok) {
            int i;
            int k = 10;
            memcpy(scan, hold, (size_t)hold_n);
            memcpy(scan + hold_n, tmp, got);
            total = hold_n + (int)got;
            for (i = 0; i + k <= total; i++) {
                if (memcmp(scan + i, "HX-BUILD-OK", (size_t)k) == 0) {
                    cap->saw_ok = 1;
                    break;
                }
            }
            if (total >= 9) {
                memcpy(hold, scan + total - 9, 9);
                hold_n = 9;
            } else {
                memcpy(hold, scan, (size_t)total);
                hold_n = total;
            }
        }
        if (cap->n < HYPER_CAPTURE - 1) {
            int room = HYPER_CAPTURE - 1 - cap->n;
            int take = (int)got < room ? (int)got : room;
            memcpy(cap->buf + cap->n, tmp, (size_t)take);
            cap->n += take;
            cap->buf[cap->n] = '\0';
        }
    }
    return 0;
}

static int hyper_swap(const char *building, const char *index)
{
    char dir[HYPER_PATH];
    char *slash;

    snprintf(dir, sizeof dir, "%s", index);
    slash = strrchr(dir, '\\');
    if (slash != NULL) {
        *slash = '\0';
        CreateDirectoryA(dir, NULL);
    }
    if (MoveFileExA(building, index, MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH))
        return 1;
    DeleteFileA(building);
    return 0;
}

typedef struct HyperJob {
    HANDLE process;
    HANDLE thread;
    HyperCapture *capture;
    HANDLE reader;
    char building[HYPER_PATH];
    char index[HYPER_PATH];
    int wait_here;
} HyperJob;

static int hyper_finish(HyperJob *job)
{
    DWORD code = 1;
    char msg[256];
    int ok;
    int entries;

    WaitForSingleObject(job->process, INFINITE);
    GetExitCodeProcess(job->process, &code);
    WaitForSingleObject(job->reader, INFINITE);
    CloseHandle(job->reader);
    CloseHandle(job->capture->read);
    CloseHandle(job->process);
    CloseHandle(job->thread);
    ok = code == 0 && job->capture->saw_ok &&
         GetFileAttributesA(job->building) != INVALID_FILE_ATTRIBUTES;
    if (!ok) {
        const char *detail = job->capture->n > 0 ? job->capture->buf : NULL;
        DeleteFileA(job->building);
        if (detail == NULL || detail[0] == '\0')
            snprintf(msg, sizeof msg, "HYPER-REINDEX: failed (child exited %lu)\n", code);
        else
            snprintf(msg, sizeof msg, "HYPER-REINDEX: failed\n");
        hyper_note(msg);
        if (detail != NULL && detail[0] != '\0' && companion_is_active())
            hyper_console(detail);
        free(job->capture);
        free(job);
        return 0;
    }
    entries = hyper_entry_count(job->building);
    if (!hyper_swap(job->building, job->index)) {
        hyper_note("HYPER-REINDEX: failed (could not replace Config/HYPER.NDX)\n");
        free(job->capture);
        free(job);
        return 0;
    }
    snprintf(msg, sizeof msg, "HYPER-REINDEX: %d entries, switched in Config/HYPER.NDX\n", entries);
    hyper_note(msg);
    if (companion_is_active() && !job->wait_here) {
        while (!companion_is_ready())
            Sleep(50);
        if (companion_is_active()) {
            int rc = companion_eval_idle("ALSO HYPER-VOC HX-APPLY-INDEX PREVIOUS");
            if (rc != 0)
                companion_status_note("HYPER-REINDEX: switched the file, reload failed\n");
        }
    }
    free(job->capture);
    free(job);
    return 1;
}

static DWORD WINAPI hyper_worker(LPVOID param)
{
    hyper_finish((HyperJob *)param);
    InterlockedExchange(&g_hyper_busy, 0);
    return 0;
}

static int hyper_launch(const char *building, HANDLE *process, HANDLE *thread, HyperCapture **out_cap, HANDLE *reader)
{
    wchar_t exe[HYPER_PATH];
    wchar_t cwd[HYPER_PATH];
    wchar_t cmd[2048];
    wchar_t pathfile[HYPER_PATH];
    char body[HYPER_PATH + 2];
    DWORD n;
    SECURITY_ATTRIBUTES sa;
    HANDLE rd = NULL;
    HANDLE wr = NULL;
    HANDLE nul = NULL;
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    HyperCapture *cap;
    HANDLE thr;
    FILE *fp = NULL;
    wchar_t temp[MAX_PATH];

    n = GetModuleFileNameW(NULL, exe, HYPER_PATH);
    if (n == 0 || n >= HYPER_PATH)
        return 0;
    if (GetTempPathW(MAX_PATH, temp) == 0)
        return 0;
    if (wcslen(temp) + 32 >= HYPER_PATH)
        return 0;
    wcscpy_s(pathfile, HYPER_PATH, temp);
    wcscat_s(pathfile, HYPER_PATH, L"editforth-hyper-path.txt");
    snprintf(body, sizeof body, "%s\n", building);
    if (_wfopen_s(&fp, pathfile, L"wb") != 0 || fp == NULL)
        return 0;
    if (fwrite(body, 1, strlen(body), fp) != strlen(body)) {
        fclose(fp);
        return 0;
    }
    fclose(fp);
    if (strchr(building, '"') != NULL || strchr(building, '\n') != NULL)
        return 0;
    n = GetCurrentDirectoryW(HYPER_PATH, cwd);
    if (n == 0 || n >= HYPER_PATH)
        cwd[0] = L'\0';
    memset(&sa, 0, sizeof sa);
    sa.nLength = sizeof sa;
    sa.bInheritHandle = TRUE;
    if (!CreatePipe(&rd, &wr, &sa, 0))
        return 0;
    SetHandleInformation(rd, HANDLE_FLAG_INHERIT, 0);
    nul = CreateFileW(L"NUL", GENERIC_READ, FILE_SHARE_READ | FILE_SHARE_WRITE, &sa,
                      OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    memset(&si, 0, sizeof si);
    si.cb = sizeof si;
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdInput = nul;
    si.hStdOutput = wr;
    si.hStdError = wr;
    _snwprintf_s(
        cmd, 2048, _TRUNCATE,
        L"\"%s\" --agent --no-autoload -e \"ONLY FORTH DEFINITIONS VOCABULARY HYPER-VOC ONLY FORTH ALSO HYPER-VOC DEFINITIONS S\\\" Library/Hyper/hyper-index.fth\\\" INCLUDED\" -e \"S\\\" %s\\\" HX-SET-OUT-FILE MIN-HYPER-NOISE ON HX-BUILD-INDEX\"",
        exe, pathfile);
    SetEnvironmentVariableA("HYPER_REINDEX_CHILD", "1");
    memset(&pi, 0, sizeof pi);
    if (!CreateProcessW(exe, cmd, NULL, NULL, TRUE, CREATE_NO_WINDOW, NULL,
                        cwd[0] != L'\0' ? cwd : NULL, &si, &pi)) {
        SetEnvironmentVariableA("HYPER_REINDEX_CHILD", NULL);
        CloseHandle(rd);
        CloseHandle(wr);
        if (nul != NULL && nul != INVALID_HANDLE_VALUE)
            CloseHandle(nul);
        return 0;
    }
    SetEnvironmentVariableA("HYPER_REINDEX_CHILD", NULL);
    CloseHandle(wr);
    if (nul != NULL && nul != INVALID_HANDLE_VALUE)
        CloseHandle(nul);
    cap = (HyperCapture *)calloc(1, sizeof *cap);
    if (cap == NULL) {
        TerminateProcess(pi.hProcess, 1);
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
        CloseHandle(rd);
        return 0;
    }
    cap->read = rd;
    thr = CreateThread(NULL, 0, hyper_capture_read, cap, 0, NULL);
    if (thr == NULL) {
        TerminateProcess(pi.hProcess, 1);
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
        CloseHandle(rd);
        free(cap);
        return 0;
    }
    *process = pi.hProcess;
    *thread = pi.hThread;
    *out_cap = cap;
    *reader = thr;
    return 1;
}

long long host_hyper_reindex(void)
{
    char *text = NULL;
    long long text_len = 0;
    char *sources_buf[HYPER_SOURCES];
    char **sources = sources_buf;
    int nsrc;
    char user[HYPER_PATH];
    char index[HYPER_PATH];
    char building[HYPER_PATH];
    char *env = NULL;
    size_t env_len = 0;
    HyperJob *job;
    HANDLE process = NULL;
    HANDLE thread = NULL;
    HANDLE reader = NULL;
    HyperCapture *capture = NULL;

    if (_dupenv_s(&env, &env_len, "HYPER_REINDEX_CHILD") == 0 && env != NULL && env[0] == '1') {
        free(env);
        return 0;
    }
    free(env);
    if (!host_documents_dir(user, sizeof user)) {
        hyper_console("HYPER-REINDEX: no source files\n");
        return 0;
    }
    text = host_hyper_source_list(&text_len);
    nsrc = hyper_split(text, sources, HYPER_SOURCES);
    free(text);
    if (nsrc <= 0) {
        hyper_console("HYPER-REINDEX: no source files\n");
        return 0;
    }
    if (!hyper_join(index, (int)sizeof index, user, "Config\\HYPER.NDX") ||
        !hyper_join(building, (int)sizeof building, user, "Config\\HYPER.NDX.building")) {
        hyper_free_list(sources, nsrc);
        hyper_console("HYPER-REINDEX: failed (path)\n");
        return 0;
    }
    if (!hyper_needs(user, index, sources, nsrc)) {
        hyper_free_list(sources, nsrc);
        hyper_console("HYPER-REINDEX: up to date\n");
        return 0;
    }
    hyper_free_list(sources, nsrc);
    if (InterlockedCompareExchange(&g_hyper_busy, 1, 0) != 0) {
        hyper_console("HYPER-REINDEX: already indexing\n");
        return 0;
    }
    if (companion_is_active())
        hyper_console("HYPER-REINDEX: indexing in the background\n");
    else
        hyper_console("HYPER-REINDEX: indexing\n");
    if (!hyper_launch(building, &process, &thread, &capture, &reader)) {
        InterlockedExchange(&g_hyper_busy, 0);
        hyper_console("HYPER-REINDEX: failed (could not start the indexer)\n");
        return 0;
    }
    job = (HyperJob *)calloc(1, sizeof *job);
    if (job == NULL) {
        TerminateProcess(process, 1);
        CloseHandle(process);
        CloseHandle(thread);
        CloseHandle(reader);
        CloseHandle(capture->read);
        free(capture);
        InterlockedExchange(&g_hyper_busy, 0);
        hyper_console("HYPER-REINDEX: failed (memory)\n");
        return 0;
    }
    job->process = process;
    job->thread = thread;
    job->capture = capture;
    job->reader = reader;
    snprintf(job->building, sizeof job->building, "%s", building);
    snprintf(job->index, sizeof job->index, "%s", index);
    if (!companion_is_active()) {
        int ok = hyper_finish(job);
        InterlockedExchange(&g_hyper_busy, 0);
        return ok ? 1 : 0;
    }
    if (CreateThread(NULL, 0, hyper_worker, job, 0, NULL) == NULL) {
        int ok;
        job->wait_here = 1;
        ok = hyper_finish(job);
        InterlockedExchange(&g_hyper_busy, 0);
        return ok ? 1 : 0;
    }
    return 0;
}
