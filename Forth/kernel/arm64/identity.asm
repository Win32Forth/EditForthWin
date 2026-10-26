; Version and build time for this kernel image.
; The console banner and the editor About box read these bytes.
; The x64 image has its own copy, so the two builds can differ.

        AREA |.rdata|, DATA, READONLY, ALIGN=3

        EXPORT kernel_version
        EXPORT kernel_built
        EXPORT kernel_console

kernel_version  DCB     "2.5.6.1", 0
        ALIGN   8
kernel_built    DCB     "Oct 26, 2026 1:54 PM", 0
        ALIGN   8
kernel_console  DCB     "EditForthWin Arm64", 0
        ALIGN   8

        END
