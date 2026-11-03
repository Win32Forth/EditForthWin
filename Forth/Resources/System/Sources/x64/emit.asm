; Generated from Forth/kernel/arm64/emit.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_x0:QWORD
EXTRN arm_x1:QWORD
EXTRN arm_x2:QWORD
EXTRN arm_x3:QWORD
EXTRN arm_x4:QWORD
EXTRN arm_x5:QWORD
EXTRN arm_x6:QWORD
EXTRN arm_x7:QWORD
EXTRN arm_x8:QWORD
EXTRN arm_x9:QWORD
EXTRN arm_x10:QWORD
EXTRN arm_x11:QWORD
EXTRN arm_x12:QWORD
EXTRN arm_x13:QWORD
EXTRN arm_x14:QWORD
EXTRN arm_x15:QWORD
EXTRN arm_x16:QWORD
EXTRN arm_x17:QWORD
EXTRN arm_x18:QWORD
EXTRN arm_x19:QWORD
EXTRN arm_x20:QWORD
EXTRN arm_x21:QWORD
EXTRN arm_x22:QWORD
EXTRN arm_x23:QWORD
EXTRN arm_x24:QWORD
EXTRN arm_x25:QWORD
EXTRN arm_x26:QWORD
EXTRN arm_x27:QWORD
EXTRN arm_x28:QWORD
EXTRN arm_x29:QWORD
EXTRN arm_x30:QWORD
EXTRN arm_n:BYTE
EXTRN arm_z:BYTE
EXTRN arm_c:BYTE
EXTRN arm_v:BYTE
EXTRN _debug_note_byte:PROC
EXTRN debug_armed:BYTE
EXTRN debug_field_count:BYTE
EXTRN debug_field_len:BYTE
EXTRN emit_fn:BYTE
EXTRN numbuf:BYTE
.CODE
PUBLIC emit_char
PUBLIC _putchar
PUBLIC emit_str
PUBLIC emit_cstr
PUBLIC emit_i64
PUBLIC _print_signed
PUBLIC _print_unsigned
PUBLIC msg_under
PUBLIC msg_full
PUBLIC msg_div0
PUBLIC msg_huh
_putchar:
emit_char:
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR [r10], rax
    ; lea x1, debug_field_count
    lea rax, debug_field_count
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, emit_char_noted
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je emit_char_noted
    ; lea x2, debug_field_len
    lea rax, debug_field_len
    mov QWORD PTR arm_x2, rax
    ; ldr     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x3, rax
    ; add     x3, x3, #1
    mov rax, QWORD PTR arm_x3
    add rax, 1
    mov QWORD PTR arm_x3, rax
    ; str     x3, [x2]
    mov r10, QWORD PTR arm_x2
    mov rax, QWORD PTR arm_x3
    mov QWORD PTR [r10], rax
emit_char_noted:
    ; lea x1, debug_armed
    lea rax, debug_armed
    mov QWORD PTR arm_x1, rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR arm_x1
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x1, rax
    ; cbz     x1, emit_char_hook
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je emit_char_hook
    ; ldr     w0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov eax, DWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
    ; bl      _debug_note_byte
    lea rax, xret_1
    mov QWORD PTR arm_x30, rax
    jmp _debug_note_byte
    xret_1:
    ; ldr     x0, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x0, rax
emit_char_hook:
    ; lea x16, emit_fn
    lea rax, emit_fn
    mov QWORD PTR arm_x16, rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR arm_x16
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x16, rax
    ; cbz     x16, emit_char_skip
    mov rax, QWORD PTR arm_x16
    cmp rax, 0
    je emit_char_skip
    ; blr     x16
    push rbx
    mov rbx, rsp
    and rsp, -16
    sub rsp, 80
    mov rcx, QWORD PTR arm_x0
    mov rdx, QWORD PTR arm_x1
    mov r8, QWORD PTR arm_x2
    mov r9, QWORD PTR arm_x3
    mov rax, QWORD PTR arm_x4
    mov QWORD PTR [rsp+32], rax
    mov rax, QWORD PTR arm_x5
    mov QWORD PTR [rsp+40], rax
    mov rax, QWORD PTR arm_x6
    mov QWORD PTR [rsp+48], rax
    mov rax, QWORD PTR arm_x7
    mov QWORD PTR [rsp+56], rax
    mov rax, QWORD PTR [rbx+8]
    mov QWORD PTR [rsp+64], rax
    mov r11, QWORD PTR arm_x16
    call r11
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
emit_char_skip:
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; ret
    jmp QWORD PTR arm_x30
emit_str:
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; mov     x20, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x20, rax
emit_str_loop:
    ; cbz     x20, emit_str_done
    mov rax, QWORD PTR arm_x20
    cmp rax, 0
    je emit_str_done
    ; ldrb    w0, [x19], #1
    mov r10, QWORD PTR arm_x19
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; bl      emit_char
    lea rax, xret_2
    mov QWORD PTR arm_x30, rax
    jmp emit_char
    xret_2:
    ; sub     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    sub rax, 1
    mov QWORD PTR arm_x20, rax
    ; b       emit_str_loop
    jmp emit_str_loop
emit_str_done:
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; ret
    jmp QWORD PTR arm_x30
emit_cstr:
    ; sub     sp, sp, #80
    mov rax, rsp
    sub rax, 50h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
emit_cstr_loop:
    ; ldrb    w0, [x19], #1
    mov r10, QWORD PTR arm_x19
    movzx eax, BYTE PTR [r10]
    mov QWORD PTR arm_x0, rax
    mov rax, QWORD PTR arm_x19
    add rax, 1
    mov QWORD PTR arm_x19, rax
    ; cbz     w0, emit_cstr_done
    mov eax, DWORD PTR arm_x0
    cmp rax, 0
    je emit_cstr_done
    ; bl      emit_char
    lea rax, xret_3
    mov QWORD PTR arm_x30, rax
    jmp emit_char
    xret_3:
    ; b       emit_cstr_loop
    jmp emit_cstr_loop
emit_cstr_done:
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #80
    mov rax, rsp
    add rax, 50h
    mov rsp, rax
    ; ret
    jmp QWORD PTR arm_x30
_print_signed:
emit_i64:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; tst     x19, x19
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x19
    test rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.pl    emit_i64_mag
    cmp BYTE PTR arm_n, 0
    je emit_i64_mag
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR arm_x0, rax
    ; lsl     x0, x0, #63
    mov rax, QWORD PTR arm_x0
    shl rax, 63
    mov QWORD PTR arm_x0, rax
    ; cmp     x19, x0
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x0
    cmp rax, rcx
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.ne    emit_i64_neg
    cmp BYTE PTR arm_z, 0
    je emit_i64_neg
    ; lea x0, msg_min
    lea rax, msg_min
    mov QWORD PTR arm_x0, rax
    ; bl      emit_cstr
    lea rax, xret_4
    mov QWORD PTR arm_x30, rax
    jmp emit_cstr
    xret_4:
    ; b       emit_i64_done
    jmp emit_i64_done
emit_i64_neg:
    ; mov     x0, #'-'
    mov rax, 2Dh
    mov QWORD PTR arm_x0, rax
    ; bl      emit_char
    lea rax, xret_5
    mov QWORD PTR arm_x30, rax
    jmp emit_char
    xret_5:
    ; neg     x19, x19
    mov rax, QWORD PTR arm_x19
    neg rax
    mov QWORD PTR arm_x19, rax
emit_i64_mag:
    ; lea x20, numbuf
    lea rax, numbuf
    mov QWORD PTR arm_x20, rax
    ; add     x20, x20, #32
    mov rax, QWORD PTR arm_x20
    add rax, 20h
    mov QWORD PTR arm_x20, rax
    ; mov     x21, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x21, rax
emit_i64_digit:
    ; udiv    x2, x19, x21
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x21
    cmp rcx, 0
    je xdiv0_7
    xor rdx, rdx
    div rcx
    jmp xdiv_6
    xdiv0_7:
    xor eax, eax
    xdiv_6:
    mov QWORD PTR arm_x2, rax
    ; msub    x3, x2, x21, x19
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x21
    imul rax, rcx
    mov rcx, QWORD PTR arm_x19
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR arm_x3, rax
    ; add     w3, w3, #'0'
    mov eax, DWORD PTR arm_x3
    add eax, 30h
    mov QWORD PTR arm_x3, rax
    ; sub     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    sub rax, 1
    mov QWORD PTR arm_x20, rax
    ; strb    w3, [x20]
    mov r10, QWORD PTR arm_x20
    mov eax, DWORD PTR arm_x3
    mov BYTE PTR [r10], al
    ; mov     x19, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x19, rax
    ; cbnz    x19, emit_i64_digit
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    jne emit_i64_digit
    ; lea x1, numbuf
    lea rax, numbuf
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #32
    mov rax, QWORD PTR arm_x1
    add rax, 20h
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      emit_str
    lea rax, xret_8
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_8:
emit_i64_done:
    ; ldp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; ret
    jmp QWORD PTR arm_x30
_print_unsigned:
    ; sub     sp, sp, #96
    mov rax, rsp
    sub rax, 60h
    mov rsp, rax
    ; stp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; stp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR arm_x19
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR arm_x21
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x22
    mov QWORD PTR [r10+8], rax
    ; mov     x19, x0
    mov rax, QWORD PTR arm_x0
    mov QWORD PTR arm_x19, rax
    ; lea x20, numbuf
    lea rax, numbuf
    mov QWORD PTR arm_x20, rax
    ; add     x20, x20, #32
    mov rax, QWORD PTR arm_x20
    add rax, 20h
    mov QWORD PTR arm_x20, rax
    ; mov     x21, #10
    mov rax, 0Ah
    mov QWORD PTR arm_x21, rax
emit_u64_digit:
    ; udiv    x2, x19, x21
    mov rax, QWORD PTR arm_x19
    mov rcx, QWORD PTR arm_x21
    cmp rcx, 0
    je xdiv0_10
    xor rdx, rdx
    div rcx
    jmp xdiv_9
    xdiv0_10:
    xor eax, eax
    xdiv_9:
    mov QWORD PTR arm_x2, rax
    ; msub    x3, x2, x21, x19
    mov rax, QWORD PTR arm_x2
    mov rcx, QWORD PTR arm_x21
    imul rax, rcx
    mov rcx, QWORD PTR arm_x19
    sub rcx, rax
    mov rax, rcx
    mov QWORD PTR arm_x3, rax
    ; add     w3, w3, #'0'
    mov eax, DWORD PTR arm_x3
    add eax, 30h
    mov QWORD PTR arm_x3, rax
    ; sub     x20, x20, #1
    mov rax, QWORD PTR arm_x20
    sub rax, 1
    mov QWORD PTR arm_x20, rax
    ; strb    w3, [x20]
    mov r10, QWORD PTR arm_x20
    mov eax, DWORD PTR arm_x3
    mov BYTE PTR [r10], al
    ; mov     x19, x2
    mov rax, QWORD PTR arm_x2
    mov QWORD PTR arm_x19, rax
    ; cbnz    x19, emit_u64_digit
    mov rax, QWORD PTR arm_x19
    cmp rax, 0
    jne emit_u64_digit
    ; lea x1, numbuf
    lea rax, numbuf
    mov QWORD PTR arm_x1, rax
    ; add     x1, x1, #32
    mov rax, QWORD PTR arm_x1
    add rax, 20h
    mov QWORD PTR arm_x1, rax
    ; sub     x1, x1, x20
    mov rax, QWORD PTR arm_x1
    mov rcx, QWORD PTR arm_x20
    sub rax, rcx
    mov QWORD PTR arm_x1, rax
    ; mov     x0, x20
    mov rax, QWORD PTR arm_x20
    mov QWORD PTR arm_x0, rax
    ; bl      emit_str
    lea rax, xret_11
    mov QWORD PTR arm_x30, rax
    jmp emit_str
    xret_11:
    ; ldp     x21, x22, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x21, rax
    mov QWORD PTR arm_x22, rcx
    ; ldp     x19, x20, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x19, rax
    mov QWORD PTR arm_x20, rcx
    ; ldp     x29, x30, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    ; add     sp, sp, #96
    mov rax, rsp
    add rax, 60h
    mov rsp, rax
    ; ret
    jmp QWORD PTR arm_x30
.CONST
msg_under:
    ; DCB     " stack empty", 10, 0
    DB " stack empty", 0Ah, 0
msg_full:
    ; DCB     " stack full", 10, 0
    DB " stack full", 0Ah, 0
msg_div0:
    ; DCB     " divide by zero", 10, 0
    DB " divide by zero", 0Ah, 0
msg_huh:
    ; DCB     " ?", 10, 0
    DB " ?", 0Ah, 0
msg_min:
    ; DCB     "-9223372036854775808", 0
    DB "-9223372036854775808", 0
END
