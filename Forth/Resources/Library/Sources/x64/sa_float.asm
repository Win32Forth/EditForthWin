; Generated from Forth/kernel/arm64/sa_float.asm. Do not edit.
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
EXTRN float_op_hook:BYTE
.CODE
PUBLIC _float_op_call
PUBLIC sa_float_bss_depth
BWSTR SEGMENT ALIGN(1) READ
nm_SA_FLOAT:
    ; DCB "(SA-FLOAT)", 0
    DB "(SA-FLOAT)", 0
hl_SA_FLOAT:
    ; DCB "(SA-FLOAT) ( -- ) stand-alone float runtime block", 0
    DB "(SA-FLOAT) ( -- ) stand-alone float runtime block", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_SA_FLOAT:
    ; DCQ     nm_SA_FLOAT, hl_SA_FLOAT
    DQ OFFSET nm_SA_FLOAT, OFFSET hl_SA_FLOAT
    ; DCD     0, FLAG_EMM
    DD 0, 40000000h
    ; DCQ     SA_FLOAT, SA_FLOAT_END
    DQ OFFSET SA_FLOAT, OFFSET SA_FLOAT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_SA_FLOAT
    DQ OFFSET row_SA_FLOAT
BOOTPTR ENDS
.CODE
SA_FLOAT:
_float_op_call:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR arm_x29, rax
    ; adr     x9, sa_float_hook_ptr
    lea rax, sa_float_hook_ptr
    mov QWORD PTR arm_x9, rax
    ; ldr     x9, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; cbnz    x9, _sff_deref
    mov rax, QWORD PTR arm_x9
    cmp rax, 0
    jne _sff_deref
    ; lea x9, float_op_hook
    lea rax, float_op_hook
    mov QWORD PTR arm_x9, rax
_sff_deref:
    ; ldr     x9, [x9]
    mov r10, QWORD PTR arm_x9
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x9, rax
    ; cbz     x9, _sa_float_local
    mov rax, QWORD PTR arm_x9
    cmp rax, 0
    je _sa_float_local
    ; sub     sp, sp, #64
    mov rax, rsp
    sub rax, 40h
    mov rsp, rax
    ; add     x6, sp, #16
    mov rax, rsp
    add rax, 10h
    mov QWORD PTR arm_x6, rax
    ; add     x7, sp, #24
    mov rax, rsp
    add rax, 18h
    mov QWORD PTR arm_x7, rax
    ; add     x8, sp, #32
    mov rax, rsp
    add rax, 20h
    mov QWORD PTR arm_x8, rax
    ; str     xzr, [x6]
    mov r10, QWORD PTR arm_x6
    mov QWORD PTR [r10], 0
    ; str     xzr, [x7]
    mov r10, QWORD PTR arm_x7
    mov QWORD PTR [r10], 0
    ; str     xzr, [x8]
    mov r10, QWORD PTR arm_x8
    mov QWORD PTR [r10], 0
    ; str     x8, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x8
    mov QWORD PTR [r10], rax
    ; blr     x9
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
    mov r11, QWORD PTR arm_x9
    call r11
    mov QWORD PTR arm_x0, rax
    mov rsp, rbx
    pop rbx
    ; ldr     x6, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; ldr     x7, [sp, #24]
    lea r10, [rsp]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x7, rax
    ; ldr     x8, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x8, rax
    ; add     sp, sp, #64
    mov rax, rsp
    add rax, 40h
    mov rsp, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_sa_fdepth_addr:
    ; adr     x10, sa_float_state_ptr
    lea rax, sa_float_state_ptr
    mov QWORD PTR arm_x10, rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x10, rax
    ; cbnz    x10, _sfd_ok
    mov rax, QWORD PTR arm_x10
    cmp rax, 0
    jne _sfd_ok
    ; lea x10, sa_float_bss_depth
    lea rax, sa_float_bss_depth
    mov QWORD PTR arm_x10, rax
_sfd_ok:
    ; ret
    jmp QWORD PTR arm_x30
_sa_fpush:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _sa_fdepth_addr
    lea rax, xret_1
    mov QWORD PTR arm_x30, rax
    jmp _sa_fdepth_addr
    xret_1:
    ; ldr     x11, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x11, rax
    ; cmp     x11, #16
    mov rax, QWORD PTR arm_x11
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.hs    _sfp_full
    cmp BYTE PTR arm_c, 0
    jne _sfp_full
    ; add     x12, x10, #16
    mov rax, QWORD PTR arm_x10
    add rax, 10h
    mov QWORD PTR arm_x12, rax
    ; str     d0, [x12, x11, lsl #3]
    mov r10, QWORD PTR arm_x12
    mov rax, QWORD PTR arm_x11
    shl rax, 3
    add r10, rax
    movsd QWORD PTR [r10], xmm0
    ; add     x11, x11, #1
    mov rax, QWORD PTR arm_x11
    add rax, 1
    mov QWORD PTR arm_x11, rax
    ; str     x11, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR arm_x11
    mov QWORD PTR [r10], rax
_sfp_full:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_sa_fpop:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR arm_x29
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR arm_x30
    mov QWORD PTR [r10+8], rax
    ; bl      _sa_fdepth_addr
    lea rax, xret_2
    mov QWORD PTR arm_x30, rax
    jmp _sa_fdepth_addr
    xret_2:
    ; ldr     x11, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x11, rax
    ; cbz     x11, _sfpop_empty
    mov rax, QWORD PTR arm_x11
    cmp rax, 0
    je _sfpop_empty
    ; sub     x11, x11, #1
    mov rax, QWORD PTR arm_x11
    sub rax, 1
    mov QWORD PTR arm_x11, rax
    ; str     x11, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR arm_x11
    mov QWORD PTR [r10], rax
    ; add     x12, x10, #16
    mov rax, QWORD PTR arm_x10
    add rax, 10h
    mov QWORD PTR arm_x12, rax
    ; ldr     d0, [x12, x11, lsl #3]
    mov r10, QWORD PTR arm_x12
    mov rax, QWORD PTR arm_x11
    shl rax, 3
    add r10, rax
    movsd xmm0, QWORD PTR [r10]
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_sfpop_empty:
    ; fmov    d0, xzr
    xorpd xmm0, xmm0
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_sa_float_local:
    ; mov     x6, #0
    mov rax, 0
    mov QWORD PTR arm_x6, rax
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR arm_x7, rax
    ; mov     x8, #0
    mov rax, 0
    mov QWORD PTR arm_x8, rax
    ; cmp     x0, #1
    mov rax, QWORD PTR arm_x0
    cmp rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fdepth
    cmp BYTE PTR arm_z, 0
    jne _saf_fdepth
    ; cmp     x0, #2
    mov rax, QWORD PTR arm_x0
    cmp rax, 2
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fdrop
    cmp BYTE PTR arm_z, 0
    jne _saf_fdrop
    ; cmp     x0, #3
    mov rax, QWORD PTR arm_x0
    cmp rax, 3
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fdup
    cmp BYTE PTR arm_z, 0
    jne _saf_fdup
    ; cmp     x0, #4
    mov rax, QWORD PTR arm_x0
    cmp rax, 4
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fswap
    cmp BYTE PTR arm_z, 0
    jne _saf_fswap
    ; cmp     x0, #5
    mov rax, QWORD PTR arm_x0
    cmp rax, 5
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fover
    cmp BYTE PTR arm_z, 0
    jne _saf_fover
    ; cmp     x0, #6
    mov rax, QWORD PTR arm_x0
    cmp rax, 6
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_frot
    cmp BYTE PTR arm_z, 0
    jne _saf_frot
    ; cmp     x0, #7
    mov rax, QWORD PTR arm_x0
    cmp rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fplus
    cmp BYTE PTR arm_z, 0
    jne _saf_fplus
    ; cmp     x0, #8
    mov rax, QWORD PTR arm_x0
    cmp rax, 8
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fminus
    cmp BYTE PTR arm_z, 0
    jne _saf_fminus
    ; cmp     x0, #9
    mov rax, QWORD PTR arm_x0
    cmp rax, 9
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fstar
    cmp BYTE PTR arm_z, 0
    jne _saf_fstar
    ; cmp     x0, #10
    mov rax, QWORD PTR arm_x0
    cmp rax, 0Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fslash
    cmp BYTE PTR arm_z, 0
    jne _saf_fslash
    ; cmp     x0, #11
    mov rax, QWORD PTR arm_x0
    cmp rax, 0Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fnegate
    cmp BYTE PTR arm_z, 0
    jne _saf_fnegate
    ; cmp     x0, #12
    mov rax, QWORD PTR arm_x0
    cmp rax, 0Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fabs
    cmp BYTE PTR arm_z, 0
    jne _saf_fabs
    ; cmp     x0, #13
    mov rax, QWORD PTR arm_x0
    cmp rax, 0Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fmax
    cmp BYTE PTR arm_z, 0
    jne _saf_fmax
    ; cmp     x0, #14
    mov rax, QWORD PTR arm_x0
    cmp rax, 0Eh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fmin
    cmp BYTE PTR arm_z, 0
    jne _saf_fmin
    ; cmp     x0, #15
    mov rax, QWORD PTR arm_x0
    cmp rax, 0Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_f0eq
    cmp BYTE PTR arm_z, 0
    jne _saf_f0eq
    ; cmp     x0, #16
    mov rax, QWORD PTR arm_x0
    cmp rax, 10h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_f0lt
    cmp BYTE PTR arm_z, 0
    jne _saf_f0lt
    ; cmp     x0, #17
    mov rax, QWORD PTR arm_x0
    cmp rax, 11h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_flt
    cmp BYTE PTR arm_z, 0
    jne _saf_flt
    ; cmp     x0, #18
    mov rax, QWORD PTR arm_x0
    cmp rax, 12h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fgt
    cmp BYTE PTR arm_z, 0
    jne _saf_fgt
    ; cmp     x0, #19
    mov rax, QWORD PTR arm_x0
    cmp rax, 13h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_feq
    cmp BYTE PTR arm_z, 0
    jne _saf_feq
    ; cmp     x0, #20
    mov rax, QWORD PTR arm_x0
    cmp rax, 14h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fne
    cmp BYTE PTR arm_z, 0
    jne _saf_fne
    ; cmp     x0, #21
    mov rax, QWORD PTR arm_x0
    cmp rax, 15h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_ftilde
    cmp BYTE PTR arm_z, 0
    jne _saf_ftilde
    ; cmp     x0, #22
    mov rax, QWORD PTR arm_x0
    cmp rax, 16h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fat
    cmp BYTE PTR arm_z, 0
    jne _saf_fat
    ; cmp     x0, #23
    mov rax, QWORD PTR arm_x0
    cmp rax, 17h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fstore
    cmp BYTE PTR arm_z, 0
    jne _saf_fstore
    ; cmp     x0, #24
    mov rax, QWORD PTR arm_x0
    cmp rax, 18h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_sfat
    cmp BYTE PTR arm_z, 0
    jne _saf_sfat
    ; cmp     x0, #25
    mov rax, QWORD PTR arm_x0
    cmp rax, 19h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_sfstore
    cmp BYTE PTR arm_z, 0
    jne _saf_sfstore
    ; cmp     x0, #26
    mov rax, QWORD PTR arm_x0
    cmp rax, 1Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fat
    cmp BYTE PTR arm_z, 0
    jne _saf_fat
    ; cmp     x0, #27
    mov rax, QWORD PTR arm_x0
    cmp rax, 1Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fstore
    cmp BYTE PTR arm_z, 0
    jne _saf_fstore
    ; cmp     x0, #28
    mov rax, QWORD PTR arm_x0
    cmp rax, 1Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_stf
    cmp BYTE PTR arm_z, 0
    jne _saf_stf
    ; cmp     x0, #29
    mov rax, QWORD PTR arm_x0
    cmp rax, 1Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fts
    cmp BYTE PTR arm_z, 0
    jne _saf_fts
    ; cmp     x0, #30
    mov rax, QWORD PTR arm_x0
    cmp rax, 1Eh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_dtf
    cmp BYTE PTR arm_z, 0
    jne _saf_dtf
    ; cmp     x0, #31
    mov rax, QWORD PTR arm_x0
    cmp rax, 1Fh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_ftd
    cmp BYTE PTR arm_z, 0
    jne _saf_ftd
    ; cmp     x0, #36
    mov rax, QWORD PTR arm_x0
    cmp rax, 24h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_precision
    cmp BYTE PTR arm_z, 0
    jne _saf_precision
    ; cmp     x0, #37
    mov rax, QWORD PTR arm_x0
    cmp rax, 25h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_setprecision
    cmp BYTE PTR arm_z, 0
    jne _saf_setprecision
    ; cmp     x0, #39
    mov rax, QWORD PTR arm_x0
    cmp rax, 27h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_floats
    cmp BYTE PTR arm_z, 0
    jne _saf_floats
    ; cmp     x0, #40
    mov rax, QWORD PTR arm_x0
    cmp rax, 28h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_floatplus
    cmp BYTE PTR arm_z, 0
    jne _saf_floatplus
    ; cmp     x0, #41
    mov rax, QWORD PTR arm_x0
    cmp rax, 29h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_sfloats
    cmp BYTE PTR arm_z, 0
    jne _saf_sfloats
    ; cmp     x0, #42
    mov rax, QWORD PTR arm_x0
    cmp rax, 2Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_sfloatplus
    cmp BYTE PTR arm_z, 0
    jne _saf_sfloatplus
    ; cmp     x0, #43
    mov rax, QWORD PTR arm_x0
    cmp rax, 2Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_floats
    cmp BYTE PTR arm_z, 0
    jne _saf_floats
    ; cmp     x0, #44
    mov rax, QWORD PTR arm_x0
    cmp rax, 2Ch
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_floatplus
    cmp BYTE PTR arm_z, 0
    jne _saf_floatplus
    ; cmp     x0, #45
    mov rax, QWORD PTR arm_x0
    cmp rax, 2Dh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fsqrt
    cmp BYTE PTR arm_z, 0
    jne _saf_fsqrt
    ; cmp     x0, #70
    mov rax, QWORD PTR arm_x0
    cmp rax, 46h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_falign
    cmp BYTE PTR arm_z, 0
    jne _saf_falign
    ; cmp     x0, #71
    mov rax, QWORD PTR arm_x0
    cmp rax, 47h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_sfalign
    cmp BYTE PTR arm_z, 0
    jne _saf_sfalign
    ; cmp     x0, #72
    mov rax, QWORD PTR arm_x0
    cmp rax, 48h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_falign
    cmp BYTE PTR arm_z, 0
    jne _saf_falign
    ; cmp     x0, #73
    mov rax, QWORD PTR arm_x0
    cmp rax, 49h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_faligned
    cmp BYTE PTR arm_z, 0
    jne _saf_faligned
    ; cmp     x0, #74
    mov rax, QWORD PTR arm_x0
    cmp rax, 4Ah
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_sfaligned
    cmp BYTE PTR arm_z, 0
    jne _saf_sfaligned
    ; cmp     x0, #75
    mov rax, QWORD PTR arm_x0
    cmp rax, 4Bh
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_faligned
    cmp BYTE PTR arm_z, 0
    jne _saf_faligned
    ; cmp     x0, #101
    mov rax, QWORD PTR arm_x0
    cmp rax, 65h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fpushbits
    cmp BYTE PTR arm_z, 0
    jne _saf_fpushbits
    ; cmp     x0, #102
    mov rax, QWORD PTR arm_x0
    cmp rax, 66h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fpopbits
    cmp BYTE PTR arm_z, 0
    jne _saf_fpopbits
    ; cmp     x0, #103
    mov rax, QWORD PTR arm_x0
    cmp rax, 67h
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_fdepth
    cmp BYTE PTR arm_z, 0
    jne _saf_fdepth
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR arm_x0, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_saf_ok:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR arm_x0, rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR arm_x29, rax
    mov QWORD PTR arm_x30, rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR arm_x30
_saf_fdepth:
    ; bl      _sa_fdepth_addr
    lea rax, xret_3
    mov QWORD PTR arm_x30, rax
    jmp _sa_fdepth_addr
    xret_3:
    ; ldr     x6, [x10]
    mov r10, QWORD PTR arm_x10
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_fdrop:
    ; bl      _sa_fpop
    lea rax, xret_4
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_4:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fdup:
    ; bl      _sa_fpop
    lea rax, xret_5
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_5:
    ; bl      _sa_fpush
    lea rax, xret_6
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_6:
    ; bl      _sa_fpush
    lea rax, xret_7
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_7:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fswap:
    ; bl      _sa_fpop
    lea rax, xret_8
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_8:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_9
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_9:
    ; fmov    d2, d0
    movsd xmm2, xmm0
    ; fmov    d0, d1
    movsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_10
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_10:
    ; fmov    d0, d2
    movsd xmm0, xmm2
    ; bl      _sa_fpush
    lea rax, xret_11
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_11:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fover:
    ; bl      _sa_fpop
    lea rax, xret_12
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_12:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_13
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_13:
    ; fmov    d2, d0
    movsd xmm2, xmm0
    ; bl      _sa_fpush
    lea rax, xret_14
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_14:
    ; fmov    d0, d1
    movsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_15
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_15:
    ; fmov    d0, d2
    movsd xmm0, xmm2
    ; bl      _sa_fpush
    lea rax, xret_16
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_16:
    ; b       _saf_ok
    jmp _saf_ok
_saf_frot:
    ; bl      _sa_fpop
    lea rax, xret_17
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_17:
    ; fmov    d3, d0
    movsd xmm3, xmm0
    ; bl      _sa_fpop
    lea rax, xret_18
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_18:
    ; fmov    d2, d0
    movsd xmm2, xmm0
    ; bl      _sa_fpop
    lea rax, xret_19
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_19:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; fmov    d0, d2
    movsd xmm0, xmm2
    ; bl      _sa_fpush
    lea rax, xret_20
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_20:
    ; fmov    d0, d3
    movsd xmm0, xmm3
    ; bl      _sa_fpush
    lea rax, xret_21
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_21:
    ; fmov    d0, d1
    movsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_22
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_22:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fplus:
    ; bl      _sa_fpop
    lea rax, xret_23
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_23:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_24
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_24:
    ; fadd    d0, d0, d1
    addsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_25
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_25:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fminus:
    ; bl      _sa_fpop
    lea rax, xret_26
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_26:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_27
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_27:
    ; fsub    d0, d0, d1
    subsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_28
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_28:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fstar:
    ; bl      _sa_fpop
    lea rax, xret_29
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_29:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_30
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_30:
    ; fmul    d0, d0, d1
    mulsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_31
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_31:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fslash:
    ; bl      _sa_fpop
    lea rax, xret_32
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_32:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_33
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_33:
    ; fdiv    d0, d0, d1
    divsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_34
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_34:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fnegate:
    ; bl      _sa_fpop
    lea rax, xret_35
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_35:
    ; fneg    d0, d0
    mov rax, 8000000000000000h
    movq xmm15, rax
    xorpd xmm0, xmm15
    ; bl      _sa_fpush
    lea rax, xret_36
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_36:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fabs:
    ; bl      _sa_fpop
    lea rax, xret_37
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_37:
    ; fabs    d0, d0
    mov rax, 7FFFFFFFFFFFFFFFh
    movq xmm15, rax
    andpd xmm0, xmm15
    ; bl      _sa_fpush
    lea rax, xret_38
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_38:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fmax:
    ; bl      _sa_fpop
    lea rax, xret_39
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_39:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_40
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_40:
    ; fmax    d0, d0, d1
    maxsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_41
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_41:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fmin:
    ; bl      _sa_fpop
    lea rax, xret_42
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_42:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_43
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_43:
    ; fmin    d0, d0, d1
    minsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_44
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_44:
    ; b       _saf_ok
    jmp _saf_ok
_saf_f0eq:
    ; bl      _sa_fpop
    lea rax, xret_45
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_45:
    ; fcmp    d0, #0.0
    xorpd xmm15, xmm15
    ucomisd xmm0, xmm15
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_46
    mov rax, -1
    xsk_46:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_f0lt:
    ; bl      _sa_fpop
    lea rax, xret_47
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_47:
    ; fcmp    d0, #0.0
    xorpd xmm15, xmm15
    ucomisd xmm0, xmm15
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, mi
    xor eax, eax
    cmp BYTE PTR arm_n, 0
    je xsk_48
    mov rax, -1
    xsk_48:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_flt:
    ; bl      _sa_fpop
    lea rax, xret_49
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_49:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_50
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_50:
    ; fcmp    d0, d1
    ucomisd xmm0, xmm1
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, mi
    xor eax, eax
    cmp BYTE PTR arm_n, 0
    je xsk_51
    mov rax, -1
    xsk_51:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_fgt:
    ; bl      _sa_fpop
    lea rax, xret_52
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_52:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_53
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_53:
    ; fcmp    d0, d1
    ucomisd xmm0, xmm1
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, gt
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_54
    mov r11b, BYTE PTR arm_n
    cmp r11b, BYTE PTR arm_v
    jne xsk_54
    mov rax, -1
    xsk_54:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_feq:
    ; bl      _sa_fpop
    lea rax, xret_55
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_55:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_56
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_56:
    ; fcmp    d0, d1
    ucomisd xmm0, xmm1
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_57
    mov rax, -1
    xsk_57:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_fne:
    ; bl      _sa_fpop
    lea rax, xret_58
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_58:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_59
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_59:
    ; fcmp    d0, d1
    ucomisd xmm0, xmm1
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, ne
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    jne xsk_60
    mov rax, -1
    xsk_60:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_ftilde:
    ; bl      _sa_fpop
    lea rax, xret_61
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_61:
    ; fabs    d2, d0
    movsd xmm2, xmm0
    mov rax, 7FFFFFFFFFFFFFFFh
    movq xmm15, rax
    andpd xmm2, xmm15
    ; bl      _sa_fpop
    lea rax, xret_62
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_62:
    ; fmov    d1, d0
    movsd xmm1, xmm0
    ; bl      _sa_fpop
    lea rax, xret_63
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_63:
    ; fsub    d0, d0, d1
    subsd xmm0, xmm1
    ; fabs    d0, d0
    mov rax, 7FFFFFFFFFFFFFFFh
    movq xmm15, rax
    andpd xmm0, xmm15
    ; fcmp    d0, d2
    ucomisd xmm0, xmm2
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x6, mi
    xor eax, eax
    cmp BYTE PTR arm_n, 0
    je xsk_64
    mov rax, -1
    xsk_64:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_fat:
    ; cbz     x1, _saf_ok
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _saf_ok
    ; ldr     d0, [x1]
    mov r10, QWORD PTR arm_x1
    movsd xmm0, QWORD PTR [r10]
    ; bl      _sa_fpush
    lea rax, xret_65
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_65:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fstore:
    ; bl      _sa_fpop
    lea rax, xret_66
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_66:
    ; cbz     x1, _saf_ok
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _saf_ok
    ; str     d0, [x1]
    mov r10, QWORD PTR arm_x1
    movsd QWORD PTR [r10], xmm0
    ; b       _saf_ok
    jmp _saf_ok
_saf_sfat:
    ; cbz     x1, _saf_ok
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _saf_ok
    ; ldr     s0, [x1]
    mov r10, QWORD PTR arm_x1
    movss xmm0, DWORD PTR [r10]
    ; fcvt    d0, s0
    cvtss2sd xmm0, xmm0
    ; bl      _sa_fpush
    lea rax, xret_67
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_67:
    ; b       _saf_ok
    jmp _saf_ok
_saf_sfstore:
    ; bl      _sa_fpop
    lea rax, xret_68
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_68:
    ; cbz     x1, _saf_ok
    mov rax, QWORD PTR arm_x1
    cmp rax, 0
    je _saf_ok
    ; fcvt    s0, d0
    cvtsd2ss xmm0, xmm0
    ; str     s0, [x1]
    mov r10, QWORD PTR arm_x1
    movss DWORD PTR [r10], xmm0
    ; b       _saf_ok
    jmp _saf_ok
_saf_stf:
    ; scvtf   d0, x1
    mov rax, QWORD PTR arm_x1
    cvtsi2sd xmm0, rax
    ; bl      _sa_fpush
    lea rax, xret_69
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_69:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fts:
    ; bl      _sa_fpop
    lea rax, xret_70
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_70:
    ; fcvtzs  x6, d0
    cvttsd2si rax, xmm0
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_dtf:
    ; cmp     x2, #0
    mov rax, QWORD PTR arm_x2
    cmp rax, 0
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setnc BYTE PTR arm_c
    ; b.eq    _saf_dtf_lo
    cmp BYTE PTR arm_z, 0
    jne _saf_dtf_lo
    ; cmn     x2, #1
    mov rax, QWORD PTR arm_x2
    add rax, 1
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; b.eq    _saf_dtf_lo
    cmp BYTE PTR arm_z, 0
    jne _saf_dtf_lo
    ; scvtf   d0, x2
    mov rax, QWORD PTR arm_x2
    cvtsi2sd xmm0, rax
    ; movz    x10, #0
    mov rax, 0
    mov QWORD PTR arm_x10, rax
    ; movk    x10, #0x43F0, lsl #48
    mov rax, QWORD PTR arm_x10
    mov rcx, 0FFFFFFFFFFFFh
    and rax, rcx
    mov rcx, 43F0000000000000h
    or rax, rcx
    mov QWORD PTR arm_x10, rax
    ; fmov    d1, x10
    mov rax, QWORD PTR arm_x10
    movq xmm1, rax
    ; fmul    d0, d0, d1
    mulsd xmm0, xmm1
    ; mov     x11, x1
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR arm_x11, rax
    ; ucvtf   d1, x11
    mov rax, QWORD PTR arm_x11
    cvtsi2sd xmm1, rax
    test rax, rax
    jns xucv_71
    mov rcx, 43F0000000000000h
    movq xmm15, rcx
    addsd xmm1, xmm15
    xucv_71:
    ; fadd    d0, d0, d1
    addsd xmm0, xmm1
    ; bl      _sa_fpush
    lea rax, xret_72
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_72:
    ; b       _saf_ok
    jmp _saf_ok
_saf_dtf_lo:
    ; scvtf   d0, x1
    mov rax, QWORD PTR arm_x1
    cvtsi2sd xmm0, rax
    ; bl      _sa_fpush
    lea rax, xret_73
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_73:
    ; b       _saf_ok
    jmp _saf_ok
_saf_ftd:
    ; bl      _sa_fpop
    lea rax, xret_74
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_74:
    ; fcvtzs  x6, d0
    cvttsd2si rax, xmm0
    mov QWORD PTR arm_x6, rax
    ; fcmp    d0, #0.0
    xorpd xmm15, xmm15
    ucomisd xmm0, xmm15
    setb al
    setp cl
    setz dl
    mov r11b, al
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_n, r11b
    mov r11b, dl
    or r11b, cl
    xor r11b, cl
    mov BYTE PTR arm_z, r11b
    mov BYTE PTR arm_v, cl
    mov r11b, BYTE PTR arm_n
    xor r11b, 1
    mov BYTE PTR arm_c, r11b
    ; csetm   x7, mi
    xor eax, eax
    cmp BYTE PTR arm_n, 0
    je xsk_75
    mov rax, -1
    xsk_75:
    mov QWORD PTR arm_x7, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_precision:
    ; bl      _sa_fdepth_addr
    lea rax, xret_76
    mov QWORD PTR arm_x30, rax
    jmp _sa_fdepth_addr
    xret_76:
    ; ldr     x6, [x10, #8]
    mov r10, QWORD PTR arm_x10
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_setprecision:
    ; bl      _sa_fdepth_addr
    lea rax, xret_77
    mov QWORD PTR arm_x30, rax
    jmp _sa_fdepth_addr
    xret_77:
    ; str     x1, [x10, #8]
    mov r10, QWORD PTR arm_x10
    add r10, 8
    mov rax, QWORD PTR arm_x1
    mov QWORD PTR [r10], rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_floats:
    ; lsl     x6, x1, #3
    mov rax, QWORD PTR arm_x1
    shl rax, 3
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_floatplus:
    ; add     x6, x1, #8
    mov rax, QWORD PTR arm_x1
    add rax, 8
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_sfloats:
    ; lsl     x6, x1, #2
    mov rax, QWORD PTR arm_x1
    shl rax, 2
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_sfloatplus:
    ; add     x6, x1, #4
    mov rax, QWORD PTR arm_x1
    add rax, 4
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_fsqrt:
    ; bl      _sa_fpop
    lea rax, xret_78
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_78:
    ; fsqrt   d0, d0
    sqrtsd xmm0, xmm0
    ; bl      _sa_fpush
    lea rax, xret_79
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_79:
    ; b       _saf_ok
    jmp _saf_ok
_saf_falign:
    ; add     x6, x1, #7
    mov rax, QWORD PTR arm_x1
    add rax, 7
    mov QWORD PTR arm_x6, rax
    ; bic     x6, x6, #7
    mov rax, QWORD PTR arm_x6
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_sfalign:
    ; add     x6, x1, #3
    mov rax, QWORD PTR arm_x1
    add rax, 3
    mov QWORD PTR arm_x6, rax
    ; bic     x6, x6, #3
    mov rax, QWORD PTR arm_x6
    mov rcx, 3
    not rcx
    and rax, rcx
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_faligned:
    ; tst     x1, #7
    mov rax, QWORD PTR arm_x1
    test rax, 7
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; csetm   x6, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_80
    mov rax, -1
    xsk_80:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_sfaligned:
    ; tst     x1, #3
    mov rax, QWORD PTR arm_x1
    test rax, 3
    seto BYTE PTR arm_v
    sets BYTE PTR arm_n
    setz BYTE PTR arm_z
    setc BYTE PTR arm_c
    ; csetm   x6, eq
    xor eax, eax
    cmp BYTE PTR arm_z, 0
    je xsk_81
    mov rax, -1
    xsk_81:
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
_saf_fpushbits:
    ; fmov    d0, x1
    mov rax, QWORD PTR arm_x1
    movq xmm0, rax
    ; bl      _sa_fpush
    lea rax, xret_82
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpush
    xret_82:
    ; b       _saf_ok
    jmp _saf_ok
_saf_fpopbits:
    ; bl      _sa_fpop
    lea rax, xret_83
    mov QWORD PTR arm_x30, rax
    jmp _sa_fpop
    xret_83:
    ; fmov    x6, d0
    movq rax, xmm0
    mov QWORD PTR arm_x6, rax
    ; b       _saf_ok
    jmp _saf_ok
    ; ALIGN 8
ALIGN 8
sa_float_hook_ptr:
    ; DCQ     0
    DQ 0
sa_float_zero_cell:
    ; DCQ     0
    DQ 0
sa_float_state_ptr:
    ; DCQ     0
    DQ 0
sa_float_pool_pad:
    ; DCQ     0
    DQ 0
SA_FLOAT_END:
.DATA
sa_float_bss_depth:
    ; DCQ     0
    DQ 0
sa_float_bss_precision:
    ; DCQ     6
    DQ 6
sa_float_bss_stack:
    ; SPACE   128
    DB 128 DUP(0)
END
