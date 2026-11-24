/* Public domain.
   Ten worker threads for CORES. schedule returns at once. A PAUSE
   (kernel_task_run result 1) keeps the same thread and the same task.
   STOP finishes the run. join blocks until every scheduled run has
   finished. wake remembers a signal that arrives before wait. */

#include "kernel_api.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

#define CORE_SLOTS 10

/* Per-thread image of x0..x30 and NZCV. xN is qword N. N is byte 248,
   Z 249, C 250, V 251. Workers and the console each have their own. */
__declspec(thread) unsigned long long arm_tls[32];

void *arm_load_base(void)
{
    return arm_tls;
}

extern unsigned long long core_sp[CORE_SLOTS];
extern unsigned long long core_task[CORE_SLOTS];
extern unsigned long long core_pthread[CORE_SLOTS];
extern int kernel_task_enter(unsigned long long task, int slot);
extern void ktr_fault_resume(void);
extern void eval_fault_resume(void);
extern unsigned long long eval_frame_sp;

static volatile LONG eval_busy;
static DWORD eval_tid;

/* kernel_init and kernel_eval arm this on the console thread. A fault
   there resumes at eval_fault_resume. Cleared before that resume so a
   second fault does not loop. */
void host_eval_fault_enter(void)
{
    eval_tid = GetCurrentThreadId();
    InterlockedExchange((LONG *)&eval_busy, 1);
}

void host_eval_fault_leave(void)
{
    InterlockedExchange((LONG *)&eval_busy, 0);
}

static CRITICAL_SECTION g_lock;
static HANDLE g_sem[CORE_SLOTS];
static HANDLE g_event[CORE_SLOTS];
static HANDLE g_thread[CORE_SLOTS];
static HANDLE g_console_sem;
static HANDLE g_join_sem;
static int g_waiting[CORE_SLOTS];
static int g_pending[CORE_SLOTS];
static int g_console_waiting;
static int g_console_pending;
static int g_depth[CORE_SLOTS];
static unsigned long long g_slot_task[CORE_SLOTS];
static unsigned long long *g_backlog;
static int g_backlog_n;
static int g_backlog_cap;
static int g_inflight;
static int g_join_waiters;
static int g_started;
static int g_ready;

static DWORD WINAPI cores_slot_main(LPVOID arg);

static void fault_resume(EXCEPTION_POINTERS *ep, unsigned long long sp, void *pc)
{
    ep->ContextRecord->ContextFlags |= CONTEXT_CONTROL;
#if defined(_M_ARM64)
    ep->ContextRecord->Sp = sp;
    ep->ContextRecord->Pc = (DWORD64)(uintptr_t)pc;
#elif defined(_M_X64)
    ep->ContextRecord->Rsp = sp;
    ep->ContextRecord->Rip = (DWORD64)(uintptr_t)pc;
#else
#error EditForthWin faults are resumed on ARM64 and x64 only
#endif
}

/* A worker memory fault resumes at ktr_fault_resume and returns -1.
   A console kernel_init or kernel_eval fault resumes at eval_fault_resume.
   Any other thread keeps searching for a handler. */
static LONG NTAPI cores_fault(EXCEPTION_POINTERS *ep)
{
    DWORD code;
    DWORD tid;
    int i;
    unsigned long long sp;
    unsigned long long task;

    code = ep->ExceptionRecord->ExceptionCode;
    if (code != EXCEPTION_ACCESS_VIOLATION &&
        code != EXCEPTION_IN_PAGE_ERROR &&
        code != EXCEPTION_DATATYPE_MISALIGNMENT)
        return EXCEPTION_CONTINUE_SEARCH;
    tid = GetCurrentThreadId();
    for (i = 0; i < CORE_SLOTS; i++) {
        if (core_pthread[i] != (unsigned long long)tid)
            continue;
        task = core_task[i];
        sp = core_sp[i];
        if (task == 0 || sp == 0 || (sp & 15ull) != 0)
            return EXCEPTION_CONTINUE_SEARCH;
        fault_resume(ep, sp, (void *)ktr_fault_resume);
        return EXCEPTION_CONTINUE_EXECUTION;
    }
    if (eval_busy && tid == eval_tid) {
        sp = eval_frame_sp;
        if (sp != 0 && (sp & 15ull) == 0) {
            InterlockedExchange((LONG *)&eval_busy, 0);
            fault_resume(ep, sp, (void *)eval_fault_resume);
            return EXCEPTION_CONTINUE_EXECUTION;
        }
    }
    return EXCEPTION_CONTINUE_SEARCH;
}

int kernel_task_run(unsigned long long task, int slot)
{
    if (task == 0 || (unsigned)slot >= CORE_SLOTS)
        return -2;
    core_pthread[slot] = (unsigned long long)GetCurrentThreadId();
    return kernel_task_enter(task, slot);
}

static int idle_slot(void)
{
    int i;

    for (i = 0; i < CORE_SLOTS; i++) {
        if (g_depth[i] == 0)
            return i;
    }
    return -1;
}

static int find_slot(unsigned long long task)
{
    int i;

    for (i = 0; i < CORE_SLOTS; i++) {
        if (g_depth[i] != 0 && g_slot_task[i] == task)
            return i;
    }
    return -1;
}

static int backlog_push(unsigned long long task)
{
    unsigned long long *grown;
    int cap;

    if (g_backlog_n >= g_backlog_cap) {
        cap = g_backlog_cap == 0 ? 32 : g_backlog_cap * 2;
        grown = (unsigned long long *)realloc(g_backlog, (size_t)cap * sizeof *grown);
        if (grown == NULL)
            return 0;
        g_backlog = grown;
        g_backlog_cap = cap;
    }
    g_backlog[g_backlog_n++] = task;
    return 1;
}

static void ensure_threads(void)
{
    int i;

    if (g_started)
        return;
    g_started = 1;
    for (i = 0; i < CORE_SLOTS; i++) {
        g_thread[i] = CreateThread(NULL, 0, cores_slot_main, (LPVOID)(intptr_t)i, 0, NULL);
    }
}

static unsigned long long finish_run(int idx)
{
    unsigned long long next = 0;
    int signal = 0;

    EnterCriticalSection(&g_lock);
    if (g_depth[idx] > 0)
        g_depth[idx]--;
    if (g_inflight > 0)
        g_inflight--;
    g_slot_task[idx] = 0;
    if (g_depth[idx] == 0 && g_backlog_n > 0) {
        int n;

        next = g_backlog[0];
        for (n = 1; n < g_backlog_n; n++)
            g_backlog[n - 1] = g_backlog[n];
        g_backlog_n--;
        g_depth[idx]++;
        g_slot_task[idx] = next;
    }
    if (g_inflight == 0 && g_join_waiters > 0) {
        g_join_waiters--;
        signal = 1;
    }
    LeaveCriticalSection(&g_lock);
    if (signal)
        ReleaseSemaphore(g_join_sem, 1, NULL);
    return next;
}

static DWORD WINAPI cores_slot_main(LPVOID arg)
{
    int idx = (int)(intptr_t)arg;

    for (;;) {
        unsigned long long task;

        WaitForSingleObject(g_event[idx], INFINITE);
        EnterCriticalSection(&g_lock);
        task = g_slot_task[idx];
        LeaveCriticalSection(&g_lock);
        while (task != 0) {
            int rc = kernel_task_run(task, idx);

            if (rc == 1)
                continue;
            if (rc < 0)
                fprintf(stderr, "core task fault\n");
            task = finish_run(idx);
        }
    }
}

static void cores_schedule(unsigned long long task)
{
    int idx;

    if (!g_ready || task == 0)
        return;
    EnterCriticalSection(&g_lock);
    ensure_threads();
    g_inflight++;
    idx = idle_slot();
    if (idx >= 0) {
        g_depth[idx]++;
        g_slot_task[idx] = task;
        LeaveCriticalSection(&g_lock);
        SetEvent(g_event[idx]);
        return;
    }
    if (!backlog_push(task)) {
        if (g_inflight > 0)
            g_inflight--;
        LeaveCriticalSection(&g_lock);
        fprintf(stderr, "core task fault\n");
        return;
    }
    LeaveCriticalSection(&g_lock);
}

static void cores_wait(unsigned long long task)
{
    int idx;

    if (!g_ready)
        return;
    EnterCriticalSection(&g_lock);
    idx = find_slot(task);
    if (idx >= 0) {
        if (g_pending[idx]) {
            g_pending[idx] = 0;
            LeaveCriticalSection(&g_lock);
            return;
        }
        g_waiting[idx] = 1;
        LeaveCriticalSection(&g_lock);
        WaitForSingleObject(g_sem[idx], INFINITE);
        EnterCriticalSection(&g_lock);
        g_waiting[idx] = 0;
        g_pending[idx] = 0;
        LeaveCriticalSection(&g_lock);
        return;
    }
    if (g_console_pending) {
        g_console_pending = 0;
        LeaveCriticalSection(&g_lock);
        return;
    }
    g_console_waiting = 1;
    LeaveCriticalSection(&g_lock);
    WaitForSingleObject(g_console_sem, INFINITE);
    EnterCriticalSection(&g_lock);
    g_console_waiting = 0;
    g_console_pending = 0;
    LeaveCriticalSection(&g_lock);
}

static void cores_wake(void)
{
    HANDLE fire[CORE_SLOTS];
    int nfire = 0;
    int fire_console = 0;
    int i;

    if (!g_ready)
        return;
    EnterCriticalSection(&g_lock);
    for (i = 0; i < CORE_SLOTS; i++) {
        if (g_waiting[i])
            fire[nfire++] = g_sem[i];
        else
            g_pending[i] = 1;
    }
    if (g_console_waiting)
        fire_console = 1;
    else
        g_console_pending = 1;
    LeaveCriticalSection(&g_lock);
    for (i = 0; i < nfire; i++)
        ReleaseSemaphore(fire[i], 1, NULL);
    if (fire_console)
        ReleaseSemaphore(g_console_sem, 1, NULL);
}

static void cores_join(void)
{
    if (!g_ready)
        return;
    EnterCriticalSection(&g_lock);
    if (g_inflight == 0) {
        LeaveCriticalSection(&g_lock);
        return;
    }
    g_join_waiters++;
    LeaveCriticalSection(&g_lock);
    WaitForSingleObject(g_join_sem, INFINITE);
}

void cores_host_init(void)
{
    int i;

    InitializeCriticalSection(&g_lock);
    g_join_sem = CreateSemaphoreA(NULL, 0, 1024, NULL);
    g_console_sem = CreateSemaphoreA(NULL, 0, 1024, NULL);
    for (i = 0; i < CORE_SLOTS; i++) {
        g_sem[i] = CreateSemaphoreA(NULL, 0, 1024, NULL);
        g_event[i] = CreateEventA(NULL, FALSE, FALSE, NULL);
    }
    g_ready = 1;
    AddVectoredExceptionHandler(1, cores_fault);
    kernel_set_core_schedule(cores_schedule);
    kernel_set_core_wait(cores_wait);
    kernel_set_core_wake(cores_wake);
    kernel_set_core_join(cores_join);
}
