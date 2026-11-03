; (SA-PRINT) — closed print span for /EMIT-STANDALONE.
; The last 32 bytes are the literal pool, in this order:
;   base_ptr, emit_hook_ptr, emit_buf_ptr, zero_cell.
; A zero pool pointer selects the host symbol (base_var / emit_fn).
; A pointer at the zero cell selects sa_win_putchar (host_out).
; In-block addresses use ADR so a moved copy keeps the same offset.
; Out-of-block ADRP+ADD pairs are the host fallback the relocator rewrites.

        EXTERN next_debug
        EXTERN debug_break_asap

        INCLUDE Forth/kernel/arm64/boot_words.inc

        AREA |.text|, CODE, READONLY, ALIGN=4

        EXTERN emit_fn
        EXTERN base_var
        EXTERN sa_win_putchar
        EXPORT _sa_putchar
        EXPORT _sa_print_signed
        EXPORT _sa_print_unsigned

        BOOT_WORD (SA-PRINT), (SA-PRINT) ( -- ) stand-alone print runtime block, FLAG_EMM, SA_PRINT, SA_PRINT_END
        BOOT_WORD (LOAD-BASE), (LOAD-BASE) ( -- ) x6 = BASE clamped 2..36, FLAG_EMM, _load_base, _load_base_end
        BOOT_WORD (DIGIT-CHAR), (DIGIT-CHAR) ( -- ) digit 0..35 to ASCII in w8, FLAG_EMM, _digit_char, _digit_char_end
        BOOT_WORD (I64>STR), (I64>STR) ( -- ) signed number to ASCII in a buffer, FLAG_EMM, _i64_to_str, _i64_to_str_end
        BOOT_WORD (U64>STR), (U64>STR) ( -- ) unsigned number to ASCII in a buffer, FLAG_EMM, _u64_to_str, _u64_to_str_end
        BOOT_WORD (PRINT-STRING), (PRINT-STRING) ( -- ) print a NUL-terminated string, FLAG_EMM, _print_string_svc, _print_string_svc_end
        BOOT_WORD (.), (.) ( n -- ) print a signed number, FLAG_EMM, _sa_print_signed, _sa_print_signed_end
        BOOT_WORD (U.), (U.) ( u -- ) print an unsigned number, FLAG_EMM, _sa_print_unsigned, _sa_print_unsigned_end

SA_PRINT
_sa_putchar
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        adr     x1, sa_print_emit_hook_ptr
        ldr     x1, [x1]
        cbnz    x1, _spc_have
        adrp    x1, emit_fn
        add     x1, x1, emit_fn
_spc_have
        ldr     x1, [x1]
        cbz     x1, _spc_win
        blr     x1
        b       _spc_done
_spc_win
        adr     x1, sa_win_putchar_ptr
        ldr     x1, [x1]
        cbz     x1, _spc_done
        blr     x1
_spc_done
        ldp     x29, x30, [sp], #16
        ret

; x0 = buffer, x1 = length. A null bulk hook prints one byte at a time.
_sa_write
        stp     x29, x30, [sp, #-32]!
        stp     x19, x20, [sp, #16]
        mov     x19, x0
        mov     x20, x1
        adr     x2, sa_print_emit_buf_ptr
        ldr     x2, [x2]
        cbz     x2, _swr_bytes
        ldr     x2, [x2]
        cbz     x2, _swr_bytes
        mov     x0, x19
        mov     x1, x20
        blr     x2
        b       _swr_done
_swr_bytes
        cbz     x20, _swr_done
_swr_loop
        ldrb    w0, [x19], #1
        bl      _sa_putchar
        sub     x20, x20, #1
        cbnz    x20, _swr_loop
_swr_done
        ldp     x19, x20, [sp, #16]
        ldp     x29, x30, [sp], #32
        ret

; -> x6 = BASE clamped to 2..36.
_load_base
        adr     x6, sa_print_base_ptr
        ldr     x6, [x6]
        cbnz    x6, _lb_have
        adrp    x6, base_var
        add     x6, x6, base_var
_lb_have
        ldr     x6, [x6]
        cmp     x6, #2
        b.lo    _lb_def
        cmp     x6, #36
        b.hi    _lb_def
        ret
_lb_def
        mov     x6, #10
        ret
_load_base_end

; w8 = digit 0..35 -> ASCII in w8.
_digit_char
        cmp     w8, #9
        b.hi    _dc_alpha
        add     w8, w8, #48
        ret
_dc_alpha
        add     w8, w8, #55
        ret
_digit_char_end

; x0 = signed value, x1 = buffer. NUL-terminated. Uses BASE.
_i64_to_str
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        stp     x19, x20, [sp, #-16]!
        mov     x2, x1
        add     x3, x1, #64
        mov     x4, x0
        mov     x5, #0
        bl      _load_base
        mov     x19, x6
        cmp     x4, #0
        b.pl    _i2s_pos
        mov     w6, #'-'
        strb    w6, [x2], #1
        neg     x4, x4
_i2s_pos
        cbnz    x4, _i2s_div
        mov     w6, #'0'
        strb    w6, [x2], #1
        strb    wzr, [x2]
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
_i2s_div
        udiv    x7, x4, x19
        msub    x8, x7, x19, x4
        bl      _digit_char
        strb    w8, [x3, #-1]!
        add     x5, x5, #1
        mov     x4, x7
        cbnz    x4, _i2s_div
_i2s_cpy
        cbz     x5, _i2s_done
        ldrb    w8, [x3], #1
        strb    w8, [x2], #1
        sub     x5, x5, #1
        b       _i2s_cpy
_i2s_done
        strb    wzr, [x2]
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
_i64_to_str_end

; x0 = unsigned value, x1 = buffer. NUL-terminated. Uses BASE.
_u64_to_str
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        stp     x19, x20, [sp, #-16]!
        mov     x2, x1
        add     x3, x1, #64
        mov     x4, x0
        mov     x5, #0
        bl      _load_base
        mov     x19, x6
        cbnz    x4, _u2s_div
        mov     w6, #'0'
        strb    w6, [x2], #1
        strb    wzr, [x2]
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
_u2s_div
        udiv    x7, x4, x19
        msub    x8, x7, x19, x4
        bl      _digit_char
        strb    w8, [x3, #-1]!
        add     x5, x5, #1
        mov     x4, x7
        cbnz    x4, _u2s_div
_u2s_cpy
        cbz     x5, _u2s_done
        ldrb    w8, [x3], #1
        strb    w8, [x2], #1
        sub     x5, x5, #1
        b       _u2s_cpy
_u2s_done
        strb    wzr, [x2]
        ldp     x19, x20, [sp], #16
        ldp     x29, x30, [sp], #16
        ret
_u64_to_str_end

; x0 = NUL-terminated string.
_print_string_svc
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        mov     x1, x0
        mov     x2, #0
_pss_len
        ldrb    w3, [x1, x2]
        cbz     w3, _pss_go
        add     x2, x2, #1
        b       _pss_len
_pss_go
        mov     x0, x1
        mov     x1, x2
        bl      _sa_write
        ldp     x29, x30, [sp], #16
        ret
_print_string_svc_end

; x0 = signed cell. No trailing space. Most-negative cell is a fixed string.
_sa_print_signed
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        mov     x1, #1
        lsl     x1, x1, #63
        cmp     x0, x1
        b.ne    _sps_norm
        adr     x0, sa_min_str
        bl      _print_string_svc
        ldp     x29, x30, [sp], #16
        ret
_sps_norm
        sub     sp, sp, #80
        mov     x1, sp
        bl      _i64_to_str
        mov     x0, sp
        bl      _print_string_svc
        add     sp, sp, #80
        ldp     x29, x30, [sp], #16
        ret
_sa_print_signed_end

; x0 = unsigned cell. No trailing space.
_sa_print_unsigned
        stp     x29, x30, [sp, #-16]!
        mov     x29, sp
        sub     sp, sp, #80
        mov     x1, sp
        bl      _u64_to_str
        mov     x0, sp
        bl      _print_string_svc
        add     sp, sp, #80
        ldp     x29, x30, [sp], #16
        ret
_sa_print_unsigned_end

        ALIGN 8
sa_min_str
        DCB     "-9223372036854775808", 0
        ALIGN 8
sa_win_putchar_ptr
        DCQ     sa_win_putchar
sa_print_base_ptr
        DCQ     0
sa_print_emit_hook_ptr
        DCQ     0
sa_print_emit_buf_ptr
        DCQ     0
sa_print_zero_cell
        DCQ     0
SA_PRINT_END

        END
