; emit-win-run.asm — ITC entry for emit-win.exe. Public domain.
; x0 = dsp (empty, grows down)  x1 = return stack (empty, grows down)
; x2 = colon CFA                x3 = gadget body cell (points at CFA of RET gadget)
; Callee-saved registers are restored when the image returns through the gadget.

        AREA |.text|, CODE, READONLY, ALIGN=4
        EXPORT run_itc

run_itc
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x28, [sp, #-16]!
        mov     x19, x0
        mov     x22, x19
        mov     x23, x1
        mov     x21, x2
        movz    x28, #0
        movz    x20, #0
        adr     x30, ew_back
        str     x30, [x23, #-8]!
        mov     x0, x3
        str     x0, [x23, #-8]!
        add     x19, x21, #8
        ldr     x21, [x19], #8
        ldr     x1, [x21]
        br      x1
ew_back
        ldp     x23, x28, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

        END
