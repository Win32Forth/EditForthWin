; Indirect-threaded Forth virtual machine. Same register map as the Mac kernel.
; Windows ARM64: x18 is reserved (TEB). x19-x28 are callee-saved, so
; kernel_eval saves the C values and reloads this map for the duration.
;
;   x20 = TOS   top of data stack
;   x19 = IP    threaded instruction pointer
;   x21 = W     current CFA
;   x22 = DSP   data stack, grows down
;   x23 = RSP   return stack, grows down
;   x24 = &latest
;   x27 = UP    user area of the task running on this thread.
;               A CORES worker sets x27 to its own task and does not
;               write up_var. Do not use x27 as scratch.
;   x28 = DBG   1 while DBG-ON is stepping. 0 takes the fast NEXT.
;
; Header, low to high, same as the Mac kernel:
;   HFA   counted help, padded to 8
;   NFA   counted name (uppercase, bit7 = SMUDGE), padded to 8
;   LFA   previous CFA of this hash thread, at CFA-16
;   FFA   flags at CFA-8
;         bits 0-15 NFA offset, 16-31 HFA offset
;         bits 32-47 view line, 48-60 file id
;         bit 61 INLINE, bit 62 EMM, bit 63 IMMEDIATE
;   CFA   code address
;   INFO  cell at CFA+8. Colon bodies start at CFA+16.
;
; NEXT: when the stepper is armed, or Break ASAP is set, go to next_debug.
; Otherwise W = CFA from *IP and br *W.
; Every file except prims_dbg.asm must EXTERN next_debug and debug_break_asap.

        MACRO
        NEXT
        cbnz    x28, next_debug_gate
        adrp    x1, debug_break_asap
        add     x1, x1, debug_break_asap
        ldr     x1, [x1]
        cbnz    x1, next_debug_gate
        ldr     x21, [x19], #8
        ldr     x1, [x21]
        br      x1
        MEND

        MACRO
        DPUSH
        str     x20, [x22, #-8]!
        mov     x20, x0
        MEND


; Per-task user cells. x27 is the task running on this thread.
; x27 == 0 (cold start, before _vm_load) falls back to up_var.
; A CORES worker leaves up_var on the console and keeps its task in x27.
TU_SRC_ADDR        EQU 104
TU_SRC_LEN         EQU 112
TU_TO_IN           EQU 120
TU_SRC_ID          EQU 128
TU_BLK             EQU 136
TU_LINE_MODE       EQU 144
TU_LINE_ORIGIN     EQU 152
TU_LINE_LIMIT      EQU 160
TU_LINE_NEXT       EQU 168
TU_ECHO_POS        EQU 176
TU_WORD_CURSOR     EQU 184
TU_SRC_SP          EQU 192
TU_HLD             EQU 200
TU_EVAL_SP         EQU 208
TU_WORD_PTR        EQU 216
TU_PAD_PTR         EQU 224
TU_INPUT_PTR       EQU 232
TU_SSTK_PTR        EQU 240
TU_EVALSTK_PTR     EQU 248

; x16 = x27 when this thread has a task, otherwise the console up_var.
; Clobbers x16 only. Does not change NZCV. Never pass x16 as $rs.
        MACRO
        UP_BASE
        mov     x16, x27
        cbnz    x16, %FT91
        adrp    x16, up_var
        add     x16, x16, up_var
        ldr     x16, [x16]
91
        MEND

        MACRO
        UP_LOAD $rd, $off
        UP_BASE
        ldr     $rd, [x16, #$off]
        MEND

        MACRO
        UP_STORE $rs, $off
        UP_BASE
        str     $rs, [x16, #$off]
        MEND

        MACRO
        UP_ADDR $rd, $off
        UP_BASE
        add     $rd, x16, #$off
        MEND

        MACRO
        UP_SRC_END $rd
        UP_BASE
        ldr     $rd, [x16, #TU_SRC_ADDR]
        ldr     x17, [x16, #TU_SRC_LEN]
        add     $rd, $rd, x17
        MEND

        END
