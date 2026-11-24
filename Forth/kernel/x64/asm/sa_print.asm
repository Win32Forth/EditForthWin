; Generated from Forth/kernel/arm64/sa_print.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_excl:QWORD
EXTRN arm_excl_addr:QWORD
EXTRN arm_excl_val:QWORD
EXTRN base_var:BYTE
EXTRN emit_fn:BYTE
EXTRN sa_win_putchar:PROC
.CODE
PUBLIC _sa_putchar
PUBLIC _sa_print_signed
PUBLIC _sa_print_unsigned
PUBLIC _print_string_svc
BWSTR SEGMENT ALIGN(1) READ
nm_SA_PRINT:
    ; DCB "(SA-PRINT)", 0
    DB "(SA-PRINT)", 0
hl_SA_PRINT:
    ; DCB "(SA-PRINT) ( -- ) stand-alone print runtime block", 0
    DB "(SA-PRINT) ( -- ) stand-alone print runtime block", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_SA_PRINT:
    ; DCQ     nm_SA_PRINT, hl_SA_PRINT
    DQ OFFSET nm_SA_PRINT, OFFSET hl_SA_PRINT
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     SA_PRINT, SA_PRINT_END
    DQ OFFSET SA_PRINT, OFFSET SA_PRINT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_SA_PRINT
    DQ OFFSET row_SA_PRINT
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__load_base:
    ; DCB "(LOAD-BASE)", 0
    DB "(LOAD-BASE)", 0
hl__load_base:
    ; DCB "(LOAD-BASE) ( -- ) x6 = BASE clamped 2..36", 0
    DB "(LOAD-BASE) ( -- ) x6 = BASE clamped 2..36", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__load_base:
    ; DCQ     nm__load_base, hl__load_base
    DQ OFFSET nm__load_base, OFFSET hl__load_base
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _load_base, _load_base_end
    DQ OFFSET _load_base, OFFSET _load_base_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__load_base
    DQ OFFSET row__load_base
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__digit_char:
    ; DCB "(DIGIT-CHAR)", 0
    DB "(DIGIT-CHAR)", 0
hl__digit_char:
    ; DCB "(DIGIT-CHAR) ( -- ) digit 0..35 to ASCII in w8", 0
    DB "(DIGIT-CHAR) ( -- ) digit 0..35 to ASCII in w8", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__digit_char:
    ; DCQ     nm__digit_char, hl__digit_char
    DQ OFFSET nm__digit_char, OFFSET hl__digit_char
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _digit_char, _digit_char_end
    DQ OFFSET _digit_char, OFFSET _digit_char_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__digit_char
    DQ OFFSET row__digit_char
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__i64_to_str:
    ; DCB "(I64>STR)", 0
    DB "(I64>STR)", 0
hl__i64_to_str:
    ; DCB "(I64>STR) ( -- ) signed number to ASCII in a buffer", 0
    DB "(I64>STR) ( -- ) signed number to ASCII in a buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__i64_to_str:
    ; DCQ     nm__i64_to_str, hl__i64_to_str
    DQ OFFSET nm__i64_to_str, OFFSET hl__i64_to_str
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _i64_to_str, _i64_to_str_end
    DQ OFFSET _i64_to_str, OFFSET _i64_to_str_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__i64_to_str
    DQ OFFSET row__i64_to_str
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__u64_to_str:
    ; DCB "(U64>STR)", 0
    DB "(U64>STR)", 0
hl__u64_to_str:
    ; DCB "(U64>STR) ( -- ) unsigned number to ASCII in a buffer", 0
    DB "(U64>STR) ( -- ) unsigned number to ASCII in a buffer", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__u64_to_str:
    ; DCQ     nm__u64_to_str, hl__u64_to_str
    DQ OFFSET nm__u64_to_str, OFFSET hl__u64_to_str
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _u64_to_str, _u64_to_str_end
    DQ OFFSET _u64_to_str, OFFSET _u64_to_str_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__u64_to_str
    DQ OFFSET row__u64_to_str
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__print_string_svc:
    ; DCB "(PRINT-STRING)", 0
    DB "(PRINT-STRING)", 0
hl__print_string_svc:
    ; DCB "(PRINT-STRING) ( -- ) print a NUL-terminated string", 0
    DB "(PRINT-STRING) ( -- ) print a NUL-terminated string", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__print_string_svc:
    ; DCQ     nm__print_string_svc, hl__print_string_svc
    DQ OFFSET nm__print_string_svc, OFFSET hl__print_string_svc
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _print_string_svc, _print_string_svc_end
    DQ OFFSET _print_string_svc, OFFSET _print_string_svc_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__print_string_svc
    DQ OFFSET row__print_string_svc
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__sa_print_signed:
    ; DCB "(.)", 0
    DB "(.)", 0
hl__sa_print_signed:
    ; DCB "(.) ( n -- ) print a signed number", 0
    DB "(.) ( n -- ) print a signed number", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__sa_print_signed:
    ; DCQ     nm__sa_print_signed, hl__sa_print_signed
    DQ OFFSET nm__sa_print_signed, OFFSET hl__sa_print_signed
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _sa_print_signed, _sa_print_signed_end
    DQ OFFSET _sa_print_signed, OFFSET _sa_print_signed_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__sa_print_signed
    DQ OFFSET row__sa_print_signed
BOOTPTR ENDS
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm__sa_print_unsigned:
    ; DCB "(U.)", 0
    DB "(U.)", 0
hl__sa_print_unsigned:
    ; DCB "(U.) ( u -- ) print an unsigned number", 0
    DB "(U.) ( u -- ) print an unsigned number", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row__sa_print_unsigned:
    ; DCQ     nm__sa_print_unsigned, hl__sa_print_unsigned
    DQ OFFSET nm__sa_print_unsigned, OFFSET hl__sa_print_unsigned
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     _sa_print_unsigned, _sa_print_unsigned_end
    DQ OFFSET _sa_print_unsigned, OFFSET _sa_print_unsigned_end
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row__sa_print_unsigned
    DQ OFFSET row__sa_print_unsigned
BOOTPTR ENDS
.CODE
SA_PRINT:
_sa_putchar:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; adr     x1, sa_print_emit_hook_ptr
    lea rax, sa_print_emit_hook_ptr
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, _spc_have
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne _spc_have
    ; lea x1, emit_fn
    lea rax, emit_fn
    mov QWORD PTR [r15+8], rax
_spc_have:
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _spc_win
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _spc_win
    ; blr     x1
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    mov r11, QWORD PTR [r15+8]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; b       _spc_done
    jmp _spc_done
_spc_win:
    ; adr     x1, sa_win_putchar_ptr
    lea rax, sa_win_putchar_ptr
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _spc_done
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _spc_done
    ; blr     x1
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    mov r11, QWORD PTR [r15+8]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
_spc_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_sa_write:
    ; stp     x29, x30, [sp, #-32]!
    add rsp, -32
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+152], rax
    ; mov     x20, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+160], rax
    ; adr     x2, sa_print_emit_buf_ptr
    lea rax, sa_print_emit_buf_ptr
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbz     x2, _swr_bytes
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    je _swr_bytes
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbz     x2, _swr_bytes
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    je _swr_bytes
    ; mov     x0, x19
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+8], rax
    ; blr     x2
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR [r15+0]
    mov rdx, QWORD PTR [r15+8]
    mov r8, QWORD PTR [r15+16]
    mov r9, QWORD PTR [r15+24]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    mov r11, QWORD PTR [r15+16]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; b       _swr_done
    jmp _swr_done
_swr_bytes:
    ; cbz     x20, _swr_done
    mov rax, QWORD PTR [r15+160]
    cmp rax, 0
    je _swr_done
_swr_loop:
    ; ldrb    w0, [x19], #1
    mov r10, QWORD PTR [r15+152]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+0], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 1
    mov QWORD PTR [r15+152], rax
    ; bl      _sa_putchar
    lea rax, xret_1
    mov QWORD PTR [r15+240], rax
    jmp _sa_putchar
    xret_1:
    ; sub     x20, x20, #1
    mov rax, QWORD PTR [r15+160]
    sub rax, 1
    mov QWORD PTR [r15+160], rax
    ; cbnz    x20, _swr_loop
    mov rax, QWORD PTR [r15+160]
    cmp rax, 0
    jne _swr_loop
_swr_done:
    ; ldp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    ; ldp     x29, x30, [sp], #32
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 20h
    ; ret
    jmp QWORD PTR [r15+240]
_load_base:
    ; adr     x6, sa_print_base_ptr
    lea rax, sa_print_base_ptr
    mov QWORD PTR [r15+48], rax
    ; ldr     x6, [x6]
    mov r10, QWORD PTR [r15+48]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; cbnz    x6, _lb_have
    mov rax, QWORD PTR [r15+48]
    cmp rax, 0
    jne _lb_have
    ; lea x6, base_var
    lea rax, base_var
    mov QWORD PTR [r15+48], rax
_lb_have:
    ; ldr     x6, [x6]
    mov r10, QWORD PTR [r15+48]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; cmp     x6, #2
    mov rax, QWORD PTR [r15+48]
    cmp rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _lb_def
    cmp BYTE PTR [r15+250], 0
    je _lb_def
    ; cmp     x6, #36
    mov rax, QWORD PTR [r15+48]
    cmp rax, 24h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _lb_def
    cmp BYTE PTR [r15+250], 0
    je xsk_2
    cmp BYTE PTR [r15+249], 0
    je _lb_def
    xsk_2:
    ; ret
    jmp QWORD PTR [r15+240]
_lb_def:
    ; mov     x6, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+48], rax
    ; ret
    jmp QWORD PTR [r15+240]
_load_base_end:
_digit_char:
    ; cmp     w8, #9
    mov eax, DWORD PTR [r15+64]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _dc_alpha
    cmp BYTE PTR [r15+250], 0
    je xsk_3
    cmp BYTE PTR [r15+249], 0
    je _dc_alpha
    xsk_3:
    ; add     w8, w8, #48
    mov eax, DWORD PTR [r15+64]
    add eax, 30h
    mov QWORD PTR [r15+64], rax
    ; ret
    jmp QWORD PTR [r15+240]
_dc_alpha:
    ; add     w8, w8, #55
    mov eax, DWORD PTR [r15+64]
    add eax, 37h
    mov QWORD PTR [r15+64], rax
    ; ret
    jmp QWORD PTR [r15+240]
_digit_char_end:
_i64_to_str:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; mov     x2, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+16], rax
    ; add     x3, x1, #64
    mov rax, QWORD PTR [r15+8]
    add rax, 40h
    mov QWORD PTR [r15+24], rax
    ; mov     x4, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+32], rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
    ; bl      _load_base
    lea rax, xret_4
    mov QWORD PTR [r15+240], rax
    jmp _load_base
    xret_4:
    ; mov     x19, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+152], rax
    ; cmp     x4, #0
    mov rax, QWORD PTR [r15+32]
    cmp rax, 0
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.pl    _i2s_pos
    cmp BYTE PTR [r15+248], 0
    je _i2s_pos
    ; mov     w6, #'-'
    mov eax, 2Dh
    mov QWORD PTR [r15+48], rax
    ; strb    w6, [x2], #1
    mov r10, QWORD PTR [r15+16]
    mov eax, DWORD PTR [r15+48]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; neg     x4, x4
    mov rax, QWORD PTR [r15+32]
    neg rax
    mov QWORD PTR [r15+32], rax
_i2s_pos:
    ; cbnz    x4, _i2s_div
    mov rax, QWORD PTR [r15+32]
    cmp rax, 0
    jne _i2s_div
    ; mov     w6, #'0'
    mov eax, 30h
    mov QWORD PTR [r15+48], rax
    ; strb    w6, [x2], #1
    mov r10, QWORD PTR [r15+16]
    mov eax, DWORD PTR [r15+48]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; strb    wzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov BYTE PTR [r10], 0
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_i2s_div:
    ; udiv    x7, x4, x19
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+152]
    cmp rcx, 0
    je xdiv0_6
    xor rdx, rdx
    div rcx
    jmp xdiv_5
    xdiv0_6:
    xor eax, eax
    xdiv_5:
    mov QWORD PTR [r15+56], rax
    ; msub    x8, x7, x19, x4
    mov rax, QWORD PTR [r15+56]
    mov rcx, QWORD PTR [r15+152]
    imul rax, rcx
    mov rcx, QWORD PTR [r15+32]
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR [r15+64], rax
    ; bl      _digit_char
    lea rax, xret_7
    mov QWORD PTR [r15+240], rax
    jmp _digit_char
    xret_7:
    ; strb    w8, [x3, #-1]!
    mov rax, QWORD PTR [r15+24]
    add rax, -1
    mov QWORD PTR [r15+24], rax
    mov r10, QWORD PTR [r15+24]
    mov eax, DWORD PTR [r15+64]
    mov BYTE PTR [r10], al
    ; add     x5, x5, #1
    mov rax, QWORD PTR [r15+40]
    add rax, 1
    mov QWORD PTR [r15+40], rax
    ; mov     x4, x7
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [r15+32], rax
    ; cbnz    x4, _i2s_div
    mov rax, QWORD PTR [r15+32]
    cmp rax, 0
    jne _i2s_div
_i2s_cpy:
    ; cbz     x5, _i2s_done
    mov rax, QWORD PTR [r15+40]
    cmp rax, 0
    je _i2s_done
    ; ldrb    w8, [x3], #1
    mov r10, QWORD PTR [r15+24]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+64], rax
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; strb    w8, [x2], #1
    mov r10, QWORD PTR [r15+16]
    mov eax, DWORD PTR [r15+64]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; sub     x5, x5, #1
    mov rax, QWORD PTR [r15+40]
    sub rax, 1
    mov QWORD PTR [r15+40], rax
    ; b       _i2s_cpy
    jmp _i2s_cpy
_i2s_done:
    ; strb    wzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov BYTE PTR [r10], 0
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_i64_to_str_end:
_u64_to_str:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; mov     x2, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+16], rax
    ; add     x3, x1, #64
    mov rax, QWORD PTR [r15+8]
    add rax, 40h
    mov QWORD PTR [r15+24], rax
    ; mov     x4, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+32], rax
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
    ; bl      _load_base
    lea rax, xret_8
    mov QWORD PTR [r15+240], rax
    jmp _load_base
    xret_8:
    ; mov     x19, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+152], rax
    ; cbnz    x4, _u2s_div
    mov rax, QWORD PTR [r15+32]
    cmp rax, 0
    jne _u2s_div
    ; mov     w6, #'0'
    mov eax, 30h
    mov QWORD PTR [r15+48], rax
    ; strb    w6, [x2], #1
    mov r10, QWORD PTR [r15+16]
    mov eax, DWORD PTR [r15+48]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; strb    wzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov BYTE PTR [r10], 0
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_u2s_div:
    ; udiv    x7, x4, x19
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+152]
    cmp rcx, 0
    je xdiv0_10
    xor rdx, rdx
    div rcx
    jmp xdiv_9
    xdiv0_10:
    xor eax, eax
    xdiv_9:
    mov QWORD PTR [r15+56], rax
    ; msub    x8, x7, x19, x4
    mov rax, QWORD PTR [r15+56]
    mov rcx, QWORD PTR [r15+152]
    imul rax, rcx
    mov rcx, QWORD PTR [r15+32]
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR [r15+64], rax
    ; bl      _digit_char
    lea rax, xret_11
    mov QWORD PTR [r15+240], rax
    jmp _digit_char
    xret_11:
    ; strb    w8, [x3, #-1]!
    mov rax, QWORD PTR [r15+24]
    add rax, -1
    mov QWORD PTR [r15+24], rax
    mov r10, QWORD PTR [r15+24]
    mov eax, DWORD PTR [r15+64]
    mov BYTE PTR [r10], al
    ; add     x5, x5, #1
    mov rax, QWORD PTR [r15+40]
    add rax, 1
    mov QWORD PTR [r15+40], rax
    ; mov     x4, x7
    mov rax, QWORD PTR [r15+56]
    mov QWORD PTR [r15+32], rax
    ; cbnz    x4, _u2s_div
    mov rax, QWORD PTR [r15+32]
    cmp rax, 0
    jne _u2s_div
_u2s_cpy:
    ; cbz     x5, _u2s_done
    mov rax, QWORD PTR [r15+40]
    cmp rax, 0
    je _u2s_done
    ; ldrb    w8, [x3], #1
    mov r10, QWORD PTR [r15+24]
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+64], rax
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+24], rax
    ; strb    w8, [x2], #1
    mov r10, QWORD PTR [r15+16]
    mov eax, DWORD PTR [r15+64]
    mov BYTE PTR [r10], al
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; sub     x5, x5, #1
    mov rax, QWORD PTR [r15+40]
    sub rax, 1
    mov QWORD PTR [r15+40], rax
    ; b       _u2s_cpy
    jmp _u2s_cpy
_u2s_done:
    ; strb    wzr, [x2]
    mov r10, QWORD PTR [r15+16]
    mov BYTE PTR [r10], 0
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_u64_to_str_end:
_print_string_svc:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; mov     x1, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR [r15+16], rax
_pss_len:
    ; ldrb    w3, [x1, x2]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+16]
    add r10, rax
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cbz     w3, _pss_go
    mov eax, DWORD PTR [r15+24]
    cmp rax, 0
    je _pss_go
    ; add     x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; b       _pss_len
    jmp _pss_len
_pss_go:
    ; mov     x0, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+0], rax
    ; mov     x1, x2
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r15+8], rax
    ; bl      _sa_write
    lea rax, xret_12
    mov QWORD PTR [r15+240], rax
    jmp _sa_write
    xret_12:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_print_string_svc_end:
_sa_print_signed:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; lsl     x1, x1, #63
    mov rax, QWORD PTR [r15+8]
    shl rax, 63
    mov QWORD PTR [r15+8], rax
    ; cmp     x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _sps_norm
    cmp BYTE PTR [r15+249], 0
    je _sps_norm
    ; adr     x0, sa_min_str
    lea rax, sa_min_str
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_13
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_13:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_sps_norm:
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; mov     x1, sp
    mov rax, rsp
    mov QWORD PTR [r15+8], rax
    ; bl      _i64_to_str
    lea rax, xret_14
    mov QWORD PTR [r15+240], rax
    jmp _i64_to_str
    xret_14:
    ; mov     x0, sp
    mov rax, rsp
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_15
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_15:
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_sa_print_signed_end:
_sa_print_unsigned:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; mov     x1, sp
    mov rax, rsp
    mov QWORD PTR [r15+8], rax
    ; bl      _u64_to_str
    lea rax, xret_16
    mov QWORD PTR [r15+240], rax
    jmp _u64_to_str
    xret_16:
    ; mov     x0, sp
    mov rax, rsp
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_17
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_17:
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_sa_print_unsigned_end:
    ; ALIGN 8
ALIGN 8
sa_min_str:
    ; DCB     "-9223372036854775808", 0
    DB "-9223372036854775808", 0
    ; ALIGN 8
ALIGN 8
sa_win_putchar_ptr:
    ; DCQ     sa_win_putchar
    DQ OFFSET sa_win_putchar
sa_print_base_ptr:
    ; DCQ     0
    DQ 0
sa_print_emit_hook_ptr:
    ; DCQ     0
    DQ 0
sa_print_emit_buf_ptr:
    ; DCQ     0
    DQ 0
sa_print_zero_cell:
    ; DCQ     0
    DQ 0
SA_PRINT_END:
END
