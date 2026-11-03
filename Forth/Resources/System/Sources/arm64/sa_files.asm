; (SA-FILES) — closed File-Access span for /EMIT-STANDALONE.
; The last 32 bytes are the literal pool, in this order:
;   hook_ptr, zero_cell, pad, pad.
; A zero hook cell selects file_op_hook (host ADRP).
; A hook that points at the zero cell selects sa_win_file_op.
; In-block addresses use ADR. The Windows pointer sits just before the pool
; so the pool patch does not overwrite it.
; In:  x0=op x1=a x2=b x3=c x4=d x5=ptr
; Out: x0=ior x6=o1 x7=o2 x8=o3

        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN file_op_hook
        EXTERN sa_win_file_op
        EXPORT _file_op_call

        BOOT_WORD (SA-FILES), (SA-FILES) ( -- ) stand-alone file runtime block, FLAG_EMM, SA_FILES, SA_FILES_END
        BOOT_WORD (FILE-OP-CALL), (FILE-OP-CALL) ( -- ) file op multiplex, FLAG_EMM, XFILE_OP_CALL, XFILE_OP_CALL_END

SA_FILES
XFILE_OP_CALL
_file_op_call
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        adr     x9, sa_files_hook_ptr
        ldr     x9, [x9]
        cbnz    x9, _sfc_have
        adrp    x9, file_op_hook
        add     x9, x9, file_op_hook
_sfc_have
        ldr     x9, [x9]
        cbz     x9, _sfc_win
        b       _sfc_call
_sfc_win
        adr     x9, sa_win_file_op_ptr
        ldr     x9, [x9]
        cbz     x9, _sfc_none
_sfc_call
        sub     sp, sp, #64
        add     x6, sp, #16
        add     x7, sp, #24
        add     x8, sp, #32
        str     xzr, [x6]
        str     xzr, [x7]
        str     xzr, [x8]
        str     x8, [sp]
        blr     x9
        ldr     x6, [sp, #16]
        ldr     x7, [sp, #24]
        ldr     x8, [sp, #32]
        add     sp, sp, #64
        ldp     x29, x30, [sp], #16
        ret
_sfc_none
        mov     x0, #-1
        mov     x6, #0
        mov     x7, #0
        mov     x8, #0
        ldp     x29, x30, [sp], #16
        ret
XFILE_OP_CALL_END

        ALIGN 8
sa_win_file_op_ptr
        DCQ     sa_win_file_op
sa_files_hook_ptr
        DCQ     0
sa_files_zero_cell
        DCQ     0
sa_files_pool_pad0
        DCQ     0
sa_files_pool_pad1
        DCQ     0
SA_FILES_END

        END
