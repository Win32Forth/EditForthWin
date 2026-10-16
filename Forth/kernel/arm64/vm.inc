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
;   x28 = DBG   1 while DBG-ON is stepping. 0 takes the fast NEXT.
;
; Header, low to high, same as the Mac kernel:
;   HFA   counted help, padded to 8
;   NFA   counted name (uppercase, bit7 = SMUDGE), padded to 8
;   LFA   previous CFA of this hash thread, at CFA-16
;   FFA   flags at CFA-8
;         bits 0-15 NFA offset, 16-31 HFA offset, bit 63 IMMEDIATE
;   CFA   code address
;   Colon words allot one cell at CFA+8 so the body starts at CFA+16.
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

        END
