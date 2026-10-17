; EMIT helpers and printing words.

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN emit_fn
        EXTERN numbuf
        EXTERN debug_field_count
        EXTERN debug_field_len
        EXTERN debug_armed
        EXTERN _debug_note_byte
        EXPORT emit_char
        EXPORT _putchar
        EXPORT emit_str
        EXPORT emit_cstr
        EXPORT emit_i64
        EXPORT _print_signed
        EXPORT _print_unsigned
        EXPORT msg_under
        EXPORT msg_full
        EXPORT msg_div0
        EXPORT msg_huh

_putchar
emit_char   PROC
        sub     sp, sp, #64
        stp     x29, x30, [sp, #32]
        str     x0, [sp, #16]
        adrp    x1, debug_field_count
        add     x1, x1, debug_field_count
        ldr     x1, [x1]
        cbz     x1, emit_char_noted
        adrp    x2, debug_field_len
        add     x2, x2, debug_field_len
        ldr     x3, [x2]
        add     x3, x3, #1
        str     x3, [x2]
emit_char_noted
        adrp    x1, debug_armed
        add     x1, x1, debug_armed
        ldr     x1, [x1]
        cbz     x1, emit_char_hook
        ldr     w0, [sp, #16]
        bl      _debug_note_byte
        ldr     x0, [sp, #16]
emit_char_hook
        adrp    x16, emit_fn
        add     x16, x16, emit_fn
        ldr     x16, [x16]
        cbz     x16, emit_char_skip
        blr     x16
emit_char_skip
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #64
        ret
        ENDP

; x0 = pointer, x1 = length
emit_str    PROC
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        mov     x19, x0
        mov     x20, x1
emit_str_loop
        cbz     x20, emit_str_done
        ldrb    w0, [x19], #1
        bl      emit_char
        sub     x20, x20, #1
        b       emit_str_loop
emit_str_done
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        ret
        ENDP

; x0 = NUL-terminated string
emit_cstr   PROC
        sub     sp, sp, #80
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        mov     x19, x0
emit_cstr_loop
        ldrb    w0, [x19], #1
        cbz     w0, emit_cstr_done
        bl      emit_char
        b       emit_cstr_loop
emit_cstr_done
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #80
        ret
        ENDP

; x0 = signed cell. Prints decimal digits, no trailing space.
_print_signed
emit_i64    PROC
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        mov     x19, x0
        tst     x19, x19
        b.pl    emit_i64_mag
        mov     x0, #1
        lsl     x0, x0, #63
        cmp     x19, x0
        b.ne    emit_i64_neg
        adrp    x0, msg_min
        add     x0, x0, msg_min
        bl      emit_cstr
        b       emit_i64_done
emit_i64_neg
        mov     x0, #'-'
        bl      emit_char
        neg     x19, x19
emit_i64_mag
        adrp    x20, numbuf
        add     x20, x20, numbuf
        add     x20, x20, #32
        mov     x21, #10
emit_i64_digit
        udiv    x2, x19, x21
        msub    x3, x2, x21, x19
        add     w3, w3, #'0'
        sub     x20, x20, #1
        strb    w3, [x20]
        mov     x19, x2
        cbnz    x19, emit_i64_digit
        adrp    x1, numbuf
        add     x1, x1, numbuf
        add     x1, x1, #32
        sub     x1, x1, x20
        mov     x0, x20
        bl      emit_str
emit_i64_done
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        ret
        ENDP

; x0 = unsigned cell. Prints decimal digits, no trailing space.
_print_unsigned PROC
        sub     sp, sp, #96
        stp     x29, x30, [sp, #32]
        stp     x19, x20, [sp, #48]
        stp     x21, x22, [sp, #64]
        mov     x19, x0
        adrp    x20, numbuf
        add     x20, x20, numbuf
        add     x20, x20, #32
        mov     x21, #10
emit_u64_digit
        udiv    x2, x19, x21
        msub    x3, x2, x21, x19
        add     w3, w3, #'0'
        sub     x20, x20, #1
        strb    w3, [x20]
        mov     x19, x2
        cbnz    x19, emit_u64_digit
        adrp    x1, numbuf
        add     x1, x1, numbuf
        add     x1, x1, #32
        sub     x1, x1, x20
        mov     x0, x20
        bl      emit_str
        ldp     x21, x22, [sp, #64]
        ldp     x19, x20, [sp, #48]
        ldp     x29, x30, [sp, #32]
        add     sp, sp, #96
        ret
        ENDP

        AREA |.rdata|, DATA, READONLY, ALIGN=3

msg_under   DCB     " stack empty", 10, 0
msg_full    DCB     " stack full", 10, 0
msg_div0    DCB     " divide by zero", 10, 0
msg_huh     DCB     " ?", 10, 0
msg_min     DCB     "-9223372036854775808", 0

        END
