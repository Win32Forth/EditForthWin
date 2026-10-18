; ITC primitives. Labels and end marks match the Mac kernel.
; The end label is the address before NEXT, which is the emitter span.

        EXTERN next_debug
        EXTERN debug_break_asap

        INCLUDE Forth/kernel/arm64/vm.inc
        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN _putchar
        EXTERN _print_signed
        EXTERN _sa_putchar
        EXTERN _sa_print_signed
        EXTERN emit_cstr
        EXTERN _print_unsigned
        EXTERN dstack
        EXTERN return_stack
        EXTERN throw_handler
        EXTERN debug_floor
        EXTERN bye_flag
        EXTERN _quit_exit
        EXTERN _interpret_loop
        EXTERN _local_frame_try_exit
        EXPORT DOCOL
        EXPORT XRESTART
        EXPORT DOEXIT
        EXPORT XLit
        EXPORT XDUP
        EXPORT XDROP
        EXPORT XSWAP
        EXPORT XOVER
        EXPORT XPLUS
        EXPORT XMINUS
        EXPORT XSTAR
        EXPORT XSLASH
        EXPORT XMOD
        EXPORT XDOT
        EXPORT XDOTS
        EXPORT XRSDOT
        EXPORT XCR
        EXPORT XBYE

        BOOT_WORD (NEXT), (NEXT) ITC dispatch, 0, XNEXT, XNEXT_END
XNEXT
        NEXT
XNEXT_END

        BOOT_WORD (DOCOL), (DOCOL) colon runtime, 0, DOCOL, DOCOL_END
DOCOL
        str     x19, [x23, #-8]!
        add     x19, x21, #16
        ldr     x0, [x19]
        cbnz    x0, DOCOL_END
        b       _quit_exit
DOCOL_END
        NEXT

        BOOT_WORD EXIT, EXIT ( -- ) return from colon definition, 0, DOEXIT, DOEXIT_END
DOEXIT
        bl      _local_frame_try_exit
        ldr     x19, [x23], #8
DOEXIT_END
        NEXT

        BOOT_WORD LIT, LIT ( -- n ) internal: literal value, 0, XLit, XLit_END
XLit
        str     x20, [x22, #-8]!
        ldr     x20, [x19], #8
XLit_END
        NEXT

        BOOT_WORD DUP, DUP ( n -- n n ) duplicate top, 0, XDUP, XDUP_END
XDUP
        str     x20, [x22, #-8]!
XDUP_END
        NEXT

        BOOT_WORD DROP, DROP ( n -- ) discard top, 0, XDROP, XDROP_END
XDROP
        ldr     x20, [x22], #8
XDROP_END
        NEXT

        BOOT_WORD SWAP, SWAP ( a b -- b a ) swap top two, 0, XSWAP, XSWAP_END
XSWAP
        ldr     x0, [x22]
        str     x20, [x22]
        mov     x20, x0
XSWAP_END
        NEXT

        BOOT_WORD OVER, OVER ( a b -- a b a ) copy second, 0, XOVER, XOVER_END
XOVER
        str     x20, [x22, #-8]!
        ldr     x20, [x22, #8]
XOVER_END
        NEXT

        BOOT_WORD +, + ( n1 n2 -- n ) addition, 0, XPLUS, XPLUS_END
XPLUS
        ldr     x0, [x22], #8
        add     x20, x20, x0
XPLUS_END
        NEXT

        BOOT_WORD -, - ( n1 n2 -- n ) subtraction, 0, XMINUS, XMINUS_END
XMINUS
        ldr     x0, [x22], #8
        sub     x20, x0, x20
XMINUS_END
        NEXT

        BOOT_WORD *, * ( n1 n2 -- n ) multiplication, 0, XSTAR, XSTAR_END
XSTAR
        ldr     x0, [x22], #8
        mul     x20, x20, x0
XSTAR_END
        NEXT

        BOOT_WORD /, / ( n1 n2 -- quot ) division (quotient), 0, XSLASH, XSLASH_END
XSLASH
        ldr     x0, [x22], #8
        sdiv    x20, x0, x20
XSLASH_END
        NEXT

        BOOT_WORD MOD, MOD ( n1 n2 -- rem ) modulo, 0, XMOD, XMOD_END
XMOD
        ldr     x0, [x22], #8
        sdiv    x1, x0, x20
        msub    x20, x1, x20, x0
XMOD_END
        NEXT

        BOOT_WORD CR, CR ( -- ) carriage return / newline, 0, XCR, XCR_END
XCR
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        mov     x0, #10
        bl      _putchar
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XCR_END
        NEXT

        BOOT_WORD ., . ( n -- ) print number (with space), 0, XDOT, XDOT_END
XDOT
        mov     x0, x20
        ldr     x20, [x22], #8
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _sa_print_signed
        mov     x0, #32
        bl      _sa_putchar
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
XDOT_END
        NEXT

        BOOT_WORD .S, .S ( -- ) print data stack contents, 0, XDOTS, 0
XDOTS
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _print_dots
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD R.S, R.S ( -- ) print return stack contents, 0, XRSDOT, 0
XRSDOT
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        bl      _print_rstack
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        NEXT

        BOOT_WORD BYE, BYE ( -- ) exit Forth to the host, 0, XBYE, XBYE_END
XBYE
        b       _quit_exit
XBYE_END

; Trampoline code. NEXT lands here after one executed xt.
; Same label as the Mac kernel: resume the outer interpreter.
XRESTART
        b       _interpret_loop

_print_dots PROC
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x25, x26, [sp, #48]
        adrp    x0, msg_open
        add     x0, x0, msg_open
        bl      emit_cstr
        adrp    x25, dstack
        add     x25, x25, dstack
        add     x25, x25, #1, lsl #12
        sub     x26, x25, x22
        lsr     x26, x26, #3
        add     x0, x26, #1
        bl      _print_signed
        adrp    x0, msg_mid
        add     x0, x0, msg_mid
        bl      emit_cstr
        sub     x25, x25, #8
_print_dots_loop
        cmp     x25, x22
        b.lo    _print_dots_tos
        ldr     x0, [x25]
        bl      _print_signed
        mov     x0, #32
        bl      _putchar
        sub     x25, x25, #8
        b       _print_dots_loop
_print_dots_tos
        mov     x0, x20
        bl      _print_signed
        mov     x0, #32
        bl      _putchar
        ldp     x25, x26, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        ret
        ENDP

; Visible cells only. A CATCH frame is six cells at throw_handler.
; The top cell is the nearest return address.
_print_rstack PROC
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        stp     x25, x26, [sp, #48]
        adrp    x25, return_stack
        add     x25, x25, return_stack
        add     x25, x25, #1, lsl #12
        adrp    x0, debug_floor
        add     x0, x0, debug_floor
        ldr     x0, [x0]
        cbz     x0, _pr_floor_keep
        cmp     x0, x25
        b.hi    _pr_floor_keep
        cmp     x0, x23
        b.ls    _pr_floor_keep
        mov     x25, x0
_pr_floor_keep
        cmp     x23, x25
        b.hs    _pr_empty
        sub     x26, x25, x23
        lsr     x26, x26, #3
        str     x26, [sp, #64]
        adrp    x0, throw_handler
        add     x0, x0, throw_handler
        ldr     x0, [x0]
        str     x0, [sp, #72]
        mov     x25, #0
        mov     x26, #0
_pr_count
        ldr     x0, [sp, #64]
        cmp     x25, x0
        b.hs    _pr_counted
        ldr     x1, [sp, #72]
        cbz     x1, _pr_count_one
        add     x2, x23, x25, lsl #3
        cmp     x2, x1
        b.ne    _pr_count_one
        add     x25, x25, #6
        b       _pr_count
_pr_count_one
        add     x26, x26, #1
        add     x25, x25, #1
        b       _pr_count
_pr_counted
        cbz     x26, _pr_empty
        str     x26, [sp, #80]
        adrp    x0, msg_open
        add     x0, x0, msg_open
        bl      emit_cstr
        ldr     x0, [sp, #80]
        bl      _print_unsigned
        adrp    x0, msg_mid
        add     x0, x0, msg_mid
        bl      emit_cstr
        mov     x25, #0
_pr_show
        ldr     x0, [sp, #64]
        cmp     x25, x0
        b.hs    _pr_done
        ldr     x1, [sp, #72]
        cbz     x1, _pr_show_one
        add     x2, x23, x25, lsl #3
        cmp     x2, x1
        b.ne    _pr_show_one
        add     x25, x25, #6
        b       _pr_show
_pr_show_one
        ldr     x0, [x23, x25, lsl #3]
        bl      _print_unsigned
        mov     x0, #32
        bl      _putchar
        add     x25, x25, #1
        b       _pr_show
_pr_empty
        adrp    x0, msg_open
        add     x0, x0, msg_open
        bl      emit_cstr
        mov     x0, #0
        bl      _print_unsigned
        adrp    x0, msg_mid
        add     x0, x0, msg_mid
        bl      emit_cstr
_pr_done
        ldp     x25, x26, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        ret
        ENDP

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16

        AREA |.rdata|, DATA, READONLY

msg_open    DCB     "( ", 0
msg_mid     DCB     " ) ", 0

        END
