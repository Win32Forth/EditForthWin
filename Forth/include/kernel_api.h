/* Public domain.
   C ABI for the Windows ARM64 and x64 console kernels.
   The Mac kernel_api.h surface grows onto these entry points.
   Returns from kernel_eval: 0 ok, 1 BYE, -2 not initialized. */

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
void kernel_set_facility_op(void (*fn)(int64_t op, int64_t a, int64_t b));

/* NUL-terminated strings owned by the kernel image. ARM64 and x64 differ. */
extern const char kernel_version[];
extern const char kernel_built[];
extern const char kernel_console[];

#ifdef __cplusplus
}
#endif

#endif
