/* Public domain.
   C ABI for the Windows ARM64 and x64 console kernels.
   The Mac kernel_api.h surface grows onto these entry points.
   Returns from kernel_eval: 0 ok, 1 BYE, -1 memory fault, -2 not initialized. */

#ifndef EDITFORTHWIN_KERNEL_API_H
#define EDITFORTHWIN_KERNEL_API_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int kernel_init(void);
int kernel_eval(const char *line, size_t n);

void kernel_set_emit(void (*fn)(int c));
void kernel_set_key(int (*fn)(void));
void kernel_set_pause(void (*fn)(void));
void kernel_set_facility_op(void (*fn)(int64_t op, int64_t a, int64_t b));

/* KEY? — non-zero when a key is waiting. Does not consume it. */
void kernel_set_key_q(int (*fn)(void));

/* CORES scheduler. schedule returns immediately. wait parks until wake.
   wake wakes every parked task. join blocks until worker runs finish.
   PAUSE requeues a worker and does not finish the run. */
void kernel_set_core_schedule(void (*fn)(uint64_t task));
void kernel_set_core_wait(void (*fn)(uint64_t task));
void kernel_set_core_wake(void (*fn)(void));
void kernel_set_core_join(void (*fn)(void));

/* Run one task on the calling thread until STOP (0), PAUSE (1), or a
   fault (-1). slot is 0..9. A bad argument returns -2. */
int kernel_task_run(uint64_t task, int slot);

/* Install the ten-thread CORES host. Call before kernel_init. */
void cores_host_init(void);

/* (HX-BG-REINDEX). 1 = the new index is in place. 0 = nothing to reload now. */
long long host_hyper_reindex(void);

/* FORGET: drop wordlists whose body is at or above the cut. */
void host_forget_drop_stale(unsigned long long cut);

/* Picture save panel. 0 stages the path, -1 is cancel or headless, -2 fails. */
long long host_app_file_save_picture(void);

/* NUL-terminated strings owned by the kernel image. ARM64 and x64 differ. */
extern const char kernel_version[];
extern const char kernel_built[];
extern const char kernel_console[];

#ifdef __cplusplus
}
#endif

#endif
