; Version and build time for the x64 kernel image.
; ml64 source, not produced by the ARM64 translator.

OPTION CASEMAP:NONE

.CONST

PUBLIC kernel_version
PUBLIC kernel_built
PUBLIC kernel_console

kernel_version DB "2.3.9.0-x64", 0
ALIGN 8
kernel_built DB "Oct 26, 2026 10:20 AM", 0
ALIGN 8
kernel_console DB "EditForthWin x64", 0
ALIGN 8

END
