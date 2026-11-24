; Generated from Forth/kernel/arm64/tasking.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_load_base:PROC
EXTRN arm_excl:QWORD
EXTRN arm_excl_addr:QWORD
EXTRN arm_excl_val:QWORD
EXTRN _do_quit:PROC
EXTRN _getchar:PROC
EXTRN _print_string_svc:PROC
EXTRN _set_source:PROC
EXTRN base_var:BYTE
EXTRN data_stack:BYTE
EXTRN debug_armed:BYTE
EXTRN debug_break_asap:BYTE
EXTRN debug_busy:BYTE
EXTRN eval_resume_stack:BYTE
EXTRN forget_cut:BYTE
EXTRN here_ptr:BYTE
EXTRN host_pause:PROC
EXTRN latest_var:BYTE
EXTRN next_debug:PROC
EXTRN pad_buffer:BYTE
EXTRN pause_hook:BYTE
EXTRN restart_cell:BYTE
EXTRN return_stack:BYTE
EXTRN source_stack:BYTE
EXTRN state_var:BYTE
EXTRN user_dict_area:BYTE
EXTRN user_dict_size_cell:BYTE
EXTRN word_scratch:BYTE
PUBLIC _task_yield
PUBLIC _dict_allot
PUBLIC _here_reserve
PUBLIC _here_reserve_exact
PUBLIC _task_dp_bounds
PUBLIC _task_require_dict
PUBLIC _task_cold_init
PUBLIC _task_forget_cut
PUBLIC _task_park_fail
PUBLIC _task_stop_or_abandon
PUBLIC _task_is_console
PUBLIC _task_other_awake
PUBLIC _task_can_switch
PUBLIC _core_console_only
PUBLIC _core_is_worker
PUBLIC _core_leave
PUBLIC _core_wake
PUBLIC _core_join_call
PUBLIC _core_wait_self
PUBLIC _core_claim_any
PUBLIC _core_claim_worker
PUBLIC _core_release_any
PUBLIC _core_release_dict
PUBLIC _core_release_worker
PUBLIC _error_abandon
PUBLIC kernel_task_enter
PUBLIC ktr_fault_resume
PUBLIC kernel_set_key_q
PUBLIC kernel_set_core_schedule
PUBLIC kernel_set_core_wait
PUBLIC kernel_set_core_wake
PUBLIC kernel_set_core_join
PUBLIC console_task
PUBLIC up_var
PUBLIC multi_var
PUBLIC cores_var
PUBLIC key_q_hook
PUBLIC eval_frame_sp
PUBLIC input_buffer
PUBLIC core_sp
PUBLIC core_task
PUBLIC core_pthread
PUBLIC sem_graphics
PUBLIC sem_console
PUBLIC sem_dict
PUBLIC park_thread
PUBLIC wait_thread
PUBLIC task_stop_thread
PUBLIC mbox_put_thread
PUBLIC mbox_get_thread
PUBLIC qput_thread
PUBLIC qget_thread
PUBLIC console_pthread
PUBLIC core_schedule_hook
PUBLIC core_wait_hook
PUBLIC core_wake_hook
PUBLIC core_join_hook
PUBLIC XSTOP
PUBLIC str_allot_over
PUBLIC str_allot_under
PUBLIC str_dict_full
.CODE
BWSTR SEGMENT ALIGN(1) READ
nm_XKEY:
    ; DCB "KEY", 0
    DB "KEY", 0
hl_XKEY:
    ; DCB "KEY ( -- c ) wait for and return next character (skips K-* function-key events)", 0
    DB "KEY ( -- c ) wait for and return next character (skips K-* function-key events)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XKEY:
    ; DCQ     nm_XKEY, hl_XKEY
    DQ OFFSET nm_XKEY, OFFSET hl_XKEY
    ; DCQ     0
    DQ 0
    ; DCQ     XKEY, XKEY_END
    DQ OFFSET XKEY, OFFSET XKEY_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XKEY
    DQ OFFSET row_XKEY
BOOTPTR ENDS
.CODE
XKEY:
xkey_poll:
    ; bl      _task_can_switch
    lea rax, xret_1
    mov QWORD PTR [r15+240], rax
    jmp _task_can_switch
    xret_1:
    ; cbz     x0, xkey_block
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je xkey_block
    ; lea x1, key_q_hook
    lea rax, key_q_hook
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, xkey_block
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je xkey_block
    ; bl      _key_poll_ready
    lea rax, xret_2
    mov QWORD PTR [r15+240], rax
    jmp _key_poll_ready
    xret_2:
    ; cbnz    x0, xkey_block
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne xkey_block
    ; lea x5, up_var
    lea rax, up_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; str     x19, [x5, #TU_RESUME]
    mov r10, QWORD PTR [r15+40]
    add r10, 50h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; add     x19, x5, #TU_RETRY_LIST
    mov rax, QWORD PTR [r15+40]
    add rax, 60h
    mov QWORD PTR [r15+152], rax
    ; bl      _task_yield
    lea rax, xret_3
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_3:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    xkey_stay
    cmp BYTE PTR [r15+249], 0
    jne xkey_stay
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
xkey_stay:
    ; ldr     x19, [x5, #TU_RESUME]
    mov r10, QWORD PTR [r15+40]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
xkey_block:
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+192]
    mov QWORD PTR [r10+8], rax
    ; bl      _getchar
    lea rax, xret_4
    mov QWORD PTR [r15+240], rax
    jmp _getchar
    xret_4:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+184], rax
    mov QWORD PTR [r15+192], rcx
    add rsp, 10h
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+168], rax
    mov QWORD PTR [r15+176], rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; mov     x1, #-2
    mov rax, -2
    mov QWORD PTR [r15+8], rax
    ; cmp     x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    xkey_char
    cmp BYTE PTR [r15+249], 0
    je xkey_char
    ; sub     x19, x19, #8
    mov rax, QWORD PTR [r15+152]
    sub rax, 8
    mov QWORD PTR [r15+152], rax
    ; b       next_debug_gate
    jmp next_debug_gate
xkey_char:
    ; mov     x1, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+8], rax
    ; lsr     x2, x1, #24
    mov rax, QWORD PTR [r15+8]
    shr rax, 24
    mov QWORD PTR [r15+16], rax
    ; and     x2, x2, #0xFF
    mov rax, QWORD PTR [r15+16]
    and rax, 0FFh
    mov QWORD PTR [r15+16], rax
    ; cmp     x2, #2
    mov rax, QWORD PTR [r15+16]
    cmp rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    xkey_poll
    cmp BYTE PTR [r15+249], 0
    jne xkey_poll
    ; cmp     x2, #1
    mov rax, QWORD PTR [r15+16]
    cmp rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    xkey_push
    cmp BYTE PTR [r15+249], 0
    je xkey_push
    ; mov     x3, #0x1FFFFF
    mov rax, 1FFFFFh
    mov QWORD PTR [r15+24], rax
    ; and     x0, x1, x3
    mov rax, QWORD PTR [r15+8]
    mov rcx, QWORD PTR [r15+24]
    and rax, rcx
    mov QWORD PTR [r15+0], rax
xkey_push:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
XKEY_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XKEYQ:
    ; DCB "KEY?", 0
    DB "KEY?", 0
hl_XKEYQ:
    ; DCB "KEY? ( -- flag ) true if a key is available (does not consume)", 0
    DB "KEY? ( -- flag ) true if a key is available (does not consume)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XKEYQ:
    ; DCQ     nm_XKEYQ, hl_XKEYQ
    DQ OFFSET nm_XKEYQ, OFFSET hl_XKEYQ
    ; DCQ     0
    DQ 0
    ; DCQ     XKEYQ, XKEYQ_END
    DQ OFFSET XKEYQ, OFFSET XKEYQ_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XKEYQ
    DQ OFFSET row_XKEYQ
BOOTPTR ENDS
.CODE
XKEYQ:
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+192]
    mov QWORD PTR [r10+8], rax
    ; lea x1, key_q_hook
    lea rax, key_q_hook
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, xkeyq_none
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je xkeyq_none
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
    ; b       xkeyq_flag
    jmp xkeyq_flag
xkeyq_none:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
xkeyq_flag:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+184], rax
    mov QWORD PTR [r15+192], rcx
    add rsp, 10h
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+168], rax
    mov QWORD PTR [r15+176], rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; cmp     x0, #0
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; csinv   x20, xzr, xzr, eq
    cmp BYTE PTR [r15+249], 0
    jne xsk_5
    xor eax, eax
    not rax
    jmp xsk_6
    xsk_5:
    xor eax, eax
    xsk_6:
    mov QWORD PTR [r15+160], rax
XKEYQ_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XPAUSE:
    ; DCB "(PAUSE-HOOK)", 0
    DB "(PAUSE-HOOK)", 0
hl_XPAUSE:
    ; DCB "(PAUSE-HOOK) ( -- ) show pending console output, then wait 1 ms", 0
    DB "(PAUSE-HOOK) ( -- ) show pending console output, then wait 1 ms", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XPAUSE:
    ; DCQ     nm_XPAUSE, hl_XPAUSE
    DQ OFFSET nm_XPAUSE, OFFSET hl_XPAUSE
    ; DCQ     0
    DQ 0
    ; DCQ     XPAUSE, XPAUSE_END
    DQ OFFSET XPAUSE, OFFSET XPAUSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XPAUSE
    DQ OFFSET row_XPAUSE
BOOTPTR ENDS
.CODE
XPAUSE:
    ; stp     x19, x20, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+192]
    mov QWORD PTR [r10+8], rax
    ; lea x1, pause_hook
    lea rax, pause_hook
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, xpause_host
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je xpause_host
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
    ; b       xpause_restore
    jmp xpause_restore
xpause_host:
    ; bl      host_pause
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
    call host_pause
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
xpause_restore:
    ; ldp     x23, x24, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+184], rax
    mov QWORD PTR [r15+192], rcx
    add rsp, 10h
    ; ldp     x21, x22, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+168], rax
    mov QWORD PTR [r15+176], rcx
    add rsp, 10h
    ; ldp     x19, x20, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    add rsp, 10h
    ; bl      _core_is_worker
    lea rax, xret_7
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_7:
    ; cbz     x0, XPAUSE_END
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je XPAUSE_END
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; b       _core_leave
    jmp _core_leave
XPAUSE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XTASK_PAUSE:
    ; DCB "PAUSE", 0
    DB "PAUSE", 0
hl_XTASK_PAUSE:
    ; DCB "PAUSE ( -- ) yield when MULTI, then show pending output and wait 1 ms", 0
    DB "PAUSE ( -- ) yield when MULTI, then show pending output and wait 1 ms", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTASK_PAUSE:
    ; DCQ     nm_XTASK_PAUSE, hl_XTASK_PAUSE
    DQ OFFSET nm_XTASK_PAUSE, OFFSET hl_XTASK_PAUSE
    ; DCQ     0
    DQ 0
    ; DCQ     XTASK_PAUSE, XTASK_PAUSE_END
    DQ OFFSET XTASK_PAUSE, OFFSET XTASK_PAUSE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTASK_PAUSE
    DQ OFFSET row_XTASK_PAUSE
BOOTPTR ENDS
.CODE
XTASK_PAUSE:
    ; bl      _task_can_switch
    lea rax, xret_8
    mov QWORD PTR [r15+240], rax
    jmp _task_can_switch
    xret_8:
    ; cbz     x0, XPAUSE
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je XPAUSE
    ; bl      _task_yield
    lea rax, xret_9
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_9:
    ; b       XPAUSE
    jmp XPAUSE
XTASK_PAUSE_END:
_task_other_awake:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _toa_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _toa_no
    ; mov     x1, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+8], rax
    ; ldr     x2, [x0, #TU_LINK]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
_toa_loop:
    ; cbz     x2, _toa_no
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    je _toa_no
    ; cmp     x2, x1
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _toa_no
    cmp BYTE PTR [r15+249], 0
    jne _toa_no
    ; ldr     x3, [x2, #TU_STATUS]
    mov r10, QWORD PTR [r15+16]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cbnz    x3, _toa_yes
    mov rax, QWORD PTR [r15+24]
    cmp rax, 0
    jne _toa_yes
    ; ldr     x2, [x2, #TU_LINK]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; b       _toa_loop
    jmp _toa_loop
_toa_yes:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_toa_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_task_can_switch:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; lea x0, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _tcs_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tcs_no
    ; lea x0, multi_var
    lea rax, multi_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _tcs_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _tcs_no
    ; lea x0, debug_armed
    lea rax, debug_armed
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _tcs_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tcs_no
    ; lea x0, debug_busy
    lea rax, debug_busy
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _tcs_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tcs_no
    ; lea x0, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _tcs_no
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tcs_no
    ; bl      _task_other_awake
    lea rax, xret_10
    mov QWORD PTR [r15+240], rax
    jmp _task_other_awake
    xret_10:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_tcs_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_key_poll_ready:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; lea x1, key_q_hook
    lea rax, key_q_hook
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _kpr_no
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _kpr_no
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
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_kpr_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_task_is_console:
    ; mov     x0, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _tic_cmp
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tic_cmp
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
_tic_cmp:
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; csinc   x0, xzr, xzr, ne
    cmp BYTE PTR [r15+249], 0
    je xsk_11
    xor eax, eax
    add rax, 1
    jmp xsk_12
    xsk_11:
    xor eax, eax
    xsk_12:
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_task_yield:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _ty_done
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _ty_done
    ; str     x19, [x0, #TU_IP]
    mov r10, QWORD PTR [r15+0]
    add r10, 10h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; str     x20, [x0, #TU_TOS]
    mov r10, QWORD PTR [r15+0]
    add r10, 18h
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; str     x22, [x0, #TU_DSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 20h
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10], rax
    ; str     x23, [x0, #TU_RSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 28h
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10], rax
    ; lea x9, base_var
    lea rax, base_var
    mov QWORD PTR [r15+72], rax
    ; ldr     x10, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; str     x10, [x0, #TU_BASE]
    mov r10, QWORD PTR [r15+0]
    add r10, 40h
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r10], rax
    ; lea x9, state_var
    lea rax, state_var
    mov QWORD PTR [r15+72], rax
    ; ldr     x10, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; str     x10, [x0, #TU_STATE]
    mov r10, QWORD PTR [r15+0]
    add r10, 48h
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r10], rax
    ; mov     x11, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+88], rax
    ; ldr     x12, [x0, #TU_LINK]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+96], rax
_ty_loop:
    ; cbz     x12, _ty_stay
    mov rax, QWORD PTR [r15+96]
    cmp rax, 0
    je _ty_stay
    ; cmp     x12, x11
    mov rax, QWORD PTR [r15+96]
    mov rcx, QWORD PTR [r15+88]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _ty_stay
    cmp BYTE PTR [r15+249], 0
    jne _ty_stay
    ; ldr     x13, [x12, #TU_STATUS]
    mov r10, QWORD PTR [r15+96]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+104], rax
    ; cbnz    x13, _ty_take
    mov rax, QWORD PTR [r15+104]
    cmp rax, 0
    jne _ty_take
    ; ldr     x12, [x12, #TU_LINK]
    mov r10, QWORD PTR [r15+96]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+96], rax
    ; b       _ty_loop
    jmp _ty_loop
_ty_take:
    ; ldr     x19, [x12, #TU_IP]
    mov r10, QWORD PTR [r15+96]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; ldr     x20, [x12, #TU_TOS]
    mov r10, QWORD PTR [r15+96]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    ; ldr     x22, [x12, #TU_DSP]
    mov r10, QWORD PTR [r15+96]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+176], rax
    ; ldr     x23, [x12, #TU_RSP]
    mov r10, QWORD PTR [r15+96]
    add r10, 28h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+184], rax
    ; ldr     x10, [x12, #TU_BASE]
    mov r10, QWORD PTR [r15+96]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; lea x9, base_var
    lea rax, base_var
    mov QWORD PTR [r15+72], rax
    ; str     x10, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r10], rax
    ; ldr     x10, [x12, #TU_STATE]
    mov r10, QWORD PTR [r15+96]
    add r10, 48h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; lea x9, state_var
    lea rax, state_var
    mov QWORD PTR [r15+72], rax
    ; str     x10, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r10], rax
    ; lea x9, up_var
    lea rax, up_var
    mov QWORD PTR [r15+72], rax
    ; str     x12, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+96]
    mov QWORD PTR [r10], rax
    ; mov     x27, x12
    mov rax, QWORD PTR [r15+96]
    mov QWORD PTR [r15+216], rax
    ; lea x9, console_task
    lea rax, console_task
    mov QWORD PTR [r15+72], rax
    ; cmp     x12, x9
    mov rax, QWORD PTR [r15+96]
    mov rcx, QWORD PTR [r15+72]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _ty_leaving_console
    cmp BYTE PTR [r15+249], 0
    je _ty_leaving_console
    ; lea x10, console_hw_sp
    lea rax, console_hw_sp
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _ty_done
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _ty_done
    ; mov     sp, x10
    mov rax, QWORD PTR [r15+80]
    mov rsp, rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_ty_leaving_console:
    ; cmp     x11, x9
    mov rax, QWORD PTR [r15+88]
    mov rcx, QWORD PTR [r15+72]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _ty_done
    cmp BYTE PTR [r15+249], 0
    je _ty_done
    ; lea x10, console_hw_sp
    lea rax, console_hw_sp
    mov QWORD PTR [r15+80], rax
    ; add     x13, sp, #16
    mov rax, rsp
    add rax, 10h
    mov QWORD PTR [r15+104], rax
    ; str     x13, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r15+104]
    mov QWORD PTR [r10], rax
    ; b       _ty_done
    jmp _ty_done
_ty_stay:
    ; ldr     x19, [x11, #TU_IP]
    mov r10, QWORD PTR [r15+88]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; ldr     x20, [x11, #TU_TOS]
    mov r10, QWORD PTR [r15+88]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    ; ldr     x22, [x11, #TU_DSP]
    mov r10, QWORD PTR [r15+88]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+176], rax
    ; ldr     x23, [x11, #TU_RSP]
    mov r10, QWORD PTR [r15+88]
    add r10, 28h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+184], rax
_ty_done:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
XKEY_RETRY:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x19, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; b       XKEY
    jmp XKEY
XPARK:
    ; lea x5, up_var
    lea rax, up_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; str     xzr, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; lea x19, park_thread
    lea rax, park_thread
    mov QWORD PTR [r15+152], rax
    ; bl      _task_yield
    lea rax, xret_13
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_13:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _xpark_alone
    cmp BYTE PTR [r15+249], 0
    jne _xpark_alone
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_xpark_alone:
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; bl      host_pause
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
    call host_pause
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; b       XPARK
    jmp XPARK
BWSTR SEGMENT ALIGN(1) READ
nm_XYIELD:
    ; DCB "(YIELD)", 0
    DB "(YIELD)", 0
hl_XYIELD:
    ; DCB "(YIELD) ( -- ) switch to the next awake task when MULTI", 0
    DB "(YIELD) ( -- ) switch to the next awake task when MULTI", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XYIELD:
    ; DCQ     nm_XYIELD, hl_XYIELD
    DQ OFFSET nm_XYIELD, OFFSET hl_XYIELD
    ; DCQ     0
    DQ 0
    ; DCQ     XYIELD, XYIELD_END
    DQ OFFSET XYIELD, OFFSET XYIELD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XYIELD
    DQ OFFSET row_XYIELD
BOOTPTR ENDS
.CODE
XYIELD:
    ; bl      _task_can_switch
    lea rax, xret_14
    mov QWORD PTR [r15+240], rax
    jmp _task_can_switch
    xret_14:
    ; cbz     x0, XYIELD_END
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je XYIELD_END
    ; bl      _task_yield
    lea rax, xret_15
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_15:
XYIELD_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XMULTI:
    ; DCB "MULTI", 0
    DB "MULTI", 0
hl_XMULTI:
    ; DCB "MULTI ( -- ) arm cooperative task switching", 0
    DB "MULTI ( -- ) arm cooperative task switching", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMULTI:
    ; DCQ     nm_XMULTI, hl_XMULTI
    DQ OFFSET nm_XMULTI, OFFSET hl_XMULTI
    ; DCQ     0
    DQ 0
    ; DCQ     XMULTI, XMULTI_END
    DQ OFFSET XMULTI, OFFSET XMULTI_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMULTI
    DQ OFFSET row_XMULTI
BOOTPTR ENDS
.CODE
XMULTI:
    ; lea x0, multi_var
    lea rax, multi_var
    mov QWORD PTR [r15+0], rax
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
XMULTI_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSINGLE:
    ; DCB "SINGLE", 0
    DB "SINGLE", 0
hl_XSINGLE:
    ; DCB "SINGLE ( -- ) cooperative PAUSE does not switch", 0
    DB "SINGLE ( -- ) cooperative PAUSE does not switch", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSINGLE:
    ; DCQ     nm_XSINGLE, hl_XSINGLE
    DQ OFFSET nm_XSINGLE, OFFSET hl_XSINGLE
    ; DCQ     0
    DQ 0
    ; DCQ     XSINGLE, XSINGLE_END
    DQ OFFSET XSINGLE, OFFSET XSINGLE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSINGLE
    DQ OFFSET row_XSINGLE
BOOTPTR ENDS
.CODE
XSINGLE:
    ; lea x0, multi_var
    lea rax, multi_var
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
XSINGLE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCORES:
    ; DCB "CORES", 0
    DB "CORES", 0
hl_XCORES:
    ; DCB "CORES ( -- ) run tasks on up to ten worker queues", 0
    DB "CORES ( -- ) run tasks on up to ten worker queues", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCORES:
    ; DCQ     nm_XCORES, hl_XCORES
    DQ OFFSET nm_XCORES, OFFSET hl_XCORES
    ; DCQ     0
    DQ 0
    ; DCQ     XCORES, XCORES_END
    DQ OFFSET XCORES, OFFSET XCORES_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCORES
    DQ OFFSET row_XCORES
BOOTPTR ENDS
.CODE
XCORES:
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x27, x1
    mov rax, QWORD PTR [r15+216]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _xcores_ok
    cmp BYTE PTR [r15+249], 0
    jne _xcores_ok
    ; lea x0, str_cores_console
    lea rax, str_cores_console
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_16
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_16:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_xcores_ok:
    ; lea x0, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+0], rax
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
XCORES_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCOOP:
    ; DCB "COOP", 0
    DB "COOP", 0
hl_XCOOP:
    ; DCB "COOP ( -- ) wait for worker tasks, then use the cooperative scheduler", 0
    DB "COOP ( -- ) wait for worker tasks, then use the cooperative scheduler", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCOOP:
    ; DCQ     nm_XCOOP, hl_XCOOP
    DQ OFFSET nm_XCOOP, OFFSET hl_XCOOP
    ; DCQ     0
    DQ 0
    ; DCQ     XCOOP, XCOOP_END
    DQ OFFSET XCOOP, OFFSET XCOOP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCOOP
    DQ OFFSET row_XCOOP
BOOTPTR ENDS
.CODE
XCOOP:
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x27, x1
    mov rax, QWORD PTR [r15+216]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _xcoop_ok
    cmp BYTE PTR [r15+249], 0
    jne _xcoop_ok
    ; lea x0, str_cores_console
    lea rax, str_cores_console
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_17
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_17:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_xcoop_ok:
    ; bl      _core_join_call
    lea rax, xret_18
    mov QWORD PTR [r15+240], rax
    jmp _core_join_call
    xret_18:
    ; lea x0, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+0], rax
    ; str     xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    mov QWORD PTR [r10], 0
XCOOP_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCORES_JOIN:
    ; DCB "CORES-JOIN", 0
    DB "CORES-JOIN", 0
hl_XCORES_JOIN:
    ; DCB "CORES-JOIN ( -- ) wait until worker tasks have stopped", 0
    DB "CORES-JOIN ( -- ) wait until worker tasks have stopped", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCORES_JOIN:
    ; DCQ     nm_XCORES_JOIN, hl_XCORES_JOIN
    DQ OFFSET nm_XCORES_JOIN, OFFSET hl_XCORES_JOIN
    ; DCQ     0
    DQ 0
    ; DCQ     XCORES_JOIN, XCORES_JOIN_END
    DQ OFFSET XCORES_JOIN, OFFSET XCORES_JOIN_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCORES_JOIN
    DQ OFFSET row_XCORES_JOIN
BOOTPTR ENDS
.CODE
XCORES_JOIN:
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x27, x1
    mov rax, QWORD PTR [r15+216]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _xjoin_ok
    cmp BYTE PTR [r15+249], 0
    jne _xjoin_ok
    ; lea x0, str_cores_console
    lea rax, str_cores_console
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_19
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_19:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_xjoin_ok:
    ; bl      _core_join_call
    lea rax, xret_20
    mov QWORD PTR [r15+240], rax
    jmp _core_join_call
    xret_20:
XCORES_JOIN_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCLAIM:
    ; DCB "CLAIM", 0
    DB "CLAIM", 0
hl_XCLAIM:
    ; DCB "CLAIM ( addr -- flag ) take a free semaphore; true if this task stored 0", 0
    DB "CLAIM ( addr -- flag ) take a free semaphore; true if this task stored 0", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCLAIM:
    ; DCQ     nm_XCLAIM, hl_XCLAIM
    DQ OFFSET nm_XCLAIM, OFFSET hl_XCLAIM
    ; DCQ     0
    DQ 0
    ; DCQ     XCLAIM, XCLAIM_END
    DQ OFFSET XCLAIM, OFFSET XCLAIM_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCLAIM
    DQ OFFSET row_XCLAIM
BOOTPTR ENDS
.CODE
XCLAIM:
    ; mov     x0, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+0], rax
_claim_try:
    ; ldaxr   x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR arm_excl_addr, r10
    mov QWORD PTR arm_excl_val, rax
    mov QWORD PTR arm_excl, 1
    ; cbz     x1, _claim_busy
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _claim_busy
    ; stlxr   w2, xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    cmp QWORD PTR arm_excl, 0
    je xxl_21
    cmp r10, QWORD PTR arm_excl_addr
    jne xxl_21
    mov rax, QWORD PTR arm_excl_val
    xor ecx, ecx
    lock cmpxchg QWORD PTR [r10], rcx
    mov QWORD PTR arm_excl, 0
    jne xxl_21
    xor eax, eax
    jmp xxl_22
    xxl_21:
    mov QWORD PTR arm_excl, 0
    mov eax, 1
    xxl_22:
    mov QWORD PTR [r15+16], rax
    ; cbnz    w2, _claim_try
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _claim_try
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR [r15+160], rax
    ; b       XCLAIM_END
    jmp XCLAIM_END
_claim_busy:
    ; clrex
    mov QWORD PTR arm_excl, 0
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
XCLAIM_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XRELEASE:
    ; DCB "RELEASE", 0
    DB "RELEASE", 0
hl_XRELEASE:
    ; DCB "RELEASE ( addr -- ) store 1 into a semaphore with a release store", 0
    DB "RELEASE ( addr -- ) store 1 into a semaphore with a release store", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XRELEASE:
    ; DCQ     nm_XRELEASE, hl_XRELEASE
    DQ OFFSET nm_XRELEASE, OFFSET hl_XRELEASE
    ; DCQ     0
    DQ 0
    ; DCQ     XRELEASE, XRELEASE_END
    DQ OFFSET XRELEASE_, OFFSET XRELEASE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XRELEASE
    DQ OFFSET row_XRELEASE
BOOTPTR ENDS
.CODE
XRELEASE_:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; stlr    x1, [x20]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; bl      _core_wake
    lea rax, xret_23
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_23:
XRELEASE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XWAIT:
    ; DCB "WAIT", 0
    DB "WAIT", 0
hl_XWAIT:
    ; DCB "WAIT ( addr -- ) CLAIM until it succeeds, yielding while the semaphore is taken", 0
    DB "WAIT ( addr -- ) CLAIM until it succeeds, yielding while the semaphore is taken", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWAIT:
    ; DCQ     nm_XWAIT, hl_XWAIT
    DQ OFFSET nm_XWAIT, OFFSET hl_XWAIT
    ; DCQ     0
    DQ 0
    ; DCQ     XWAIT, XWAIT_END
    DQ OFFSET XWAIT, OFFSET XWAIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWAIT
    DQ OFFSET row_XWAIT
BOOTPTR ENDS
.CODE
XWAIT_RETRY:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x19, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; b       XWAIT
    jmp XWAIT
XWAIT:
    ; mov     x0, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+0], rax
_wait_try:
    ; ldaxr   x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR arm_excl_addr, r10
    mov QWORD PTR arm_excl_val, rax
    mov QWORD PTR arm_excl, 1
    ; cbz     x1, _wait_busy
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _wait_busy
    ; stlxr   w2, xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    cmp QWORD PTR arm_excl, 0
    je xxl_24
    cmp r10, QWORD PTR arm_excl_addr
    jne xxl_24
    mov rax, QWORD PTR arm_excl_val
    xor ecx, ecx
    lock cmpxchg QWORD PTR [r10], rcx
    mov QWORD PTR arm_excl, 0
    jne xxl_24
    xor eax, eax
    jmp xxl_25
    xxl_24:
    mov QWORD PTR arm_excl, 0
    mov eax, 1
    xxl_25:
    mov QWORD PTR [r15+16], rax
    ; cbnz    w2, _wait_try
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _wait_try
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; b       XWAIT_END
    jmp XWAIT_END
_wait_busy:
    ; clrex
    mov QWORD PTR arm_excl, 0
    ; bl      _core_wait_self
    lea rax, xret_26
    mov QWORD PTR [r15+240], rax
    jmp _core_wait_self
    xret_26:
    ; cbz     x0, _wait_coop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _wait_coop
    ; b       XWAIT
    jmp XWAIT
_wait_coop:
    ; bl      _task_can_switch
    lea rax, xret_27
    mov QWORD PTR [r15+240], rax
    jmp _task_can_switch
    xret_27:
    ; cbz     x0, _wait_stuck
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _wait_stuck
    ; lea x5, up_var
    lea rax, up_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; str     x19, [x5, #TU_RESUME]
    mov r10, QWORD PTR [r15+40]
    add r10, 50h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; lea x19, wait_thread
    lea rax, wait_thread
    mov QWORD PTR [r15+152], rax
    ; bl      _task_yield
    lea rax, xret_28
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_28:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    XWAIT_END
    cmp BYTE PTR [r15+249], 0
    je XWAIT_END
    ; ldr     x19, [x5, #TU_RESUME]
    mov r10, QWORD PTR [r15+40]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
_wait_stuck:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; lea x0, str_wait_stuck
    lea rax, str_wait_stuck
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_29
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_29:
XWAIT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSIGNAL:
    ; DCB "SIGNAL", 0
    DB "SIGNAL", 0
hl_XSIGNAL:
    ; DCB "SIGNAL ( addr -- ) RELEASE, then yield so a waiting task can CLAIM", 0
    DB "SIGNAL ( addr -- ) RELEASE, then yield so a waiting task can CLAIM", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSIGNAL:
    ; DCQ     nm_XSIGNAL, hl_XSIGNAL
    DQ OFFSET nm_XSIGNAL, OFFSET hl_XSIGNAL
    ; DCQ     0
    DQ 0
    ; DCQ     XSIGNAL, XSIGNAL_END
    DQ OFFSET XSIGNAL, OFFSET XSIGNAL_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSIGNAL
    DQ OFFSET row_XSIGNAL
BOOTPTR ENDS
.CODE
XSIGNAL:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; stlr    x1, [x20]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; bl      _core_wake
    lea rax, xret_30
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_30:
    ; bl      _task_can_switch
    lea rax, xret_31
    mov QWORD PTR [r15+240], rax
    jmp _task_can_switch
    xret_31:
    ; cbz     x0, XSIGNAL_END
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je XSIGNAL_END
    ; bl      _task_yield
    lea rax, xret_32
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_32:
XSIGNAL_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XGRAPHICS_SEM:
    ; DCB "GRAPHICS-SEM", 0
    DB "GRAPHICS-SEM", 0
hl_XGRAPHICS_SEM:
    ; DCB "GRAPHICS-SEM ( -- addr ) semaphore for the graphics map (1 = free)", 0
    DB "GRAPHICS-SEM ( -- addr ) semaphore for the graphics map (1 = free)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XGRAPHICS_SEM:
    ; DCQ     nm_XGRAPHICS_SEM, hl_XGRAPHICS_SEM
    DQ OFFSET nm_XGRAPHICS_SEM, OFFSET hl_XGRAPHICS_SEM
    ; DCQ     0
    DQ 0
    ; DCQ     XGRAPHICS_SEM, 0
    DQ OFFSET XGRAPHICS_SEM, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XGRAPHICS_SEM
    DQ OFFSET row_XGRAPHICS_SEM
BOOTPTR ENDS
.CODE
XGRAPHICS_SEM:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; lea x20, sem_graphics
    lea rax, sem_graphics
    mov QWORD PTR [r15+160], rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCONSOLE_SEM:
    ; DCB "CONSOLE-SEM", 0
    DB "CONSOLE-SEM", 0
hl_XCONSOLE_SEM:
    ; DCB "CONSOLE-SEM ( -- addr ) semaphore for the console emit buffer (1 = free)", 0
    DB "CONSOLE-SEM ( -- addr ) semaphore for the console emit buffer (1 = free)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCONSOLE_SEM:
    ; DCQ     nm_XCONSOLE_SEM, hl_XCONSOLE_SEM
    DQ OFFSET nm_XCONSOLE_SEM, OFFSET hl_XCONSOLE_SEM
    ; DCQ     0
    DQ 0
    ; DCQ     XCONSOLE_SEM, 0
    DQ OFFSET XCONSOLE_SEM, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCONSOLE_SEM
    DQ OFFSET row_XCONSOLE_SEM
BOOTPTR ENDS
.CODE
XCONSOLE_SEM:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; lea x20, sem_console
    lea rax, sem_console
    mov QWORD PTR [r15+160], rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XDICT_SEM:
    ; DCB "DICT-SEM", 0
    DB "DICT-SEM", 0
hl_XDICT_SEM:
    ; DCB "DICT-SEM ( -- addr ) semaphore for dictionary mutation (1 = free)", 0
    DB "DICT-SEM ( -- addr ) semaphore for dictionary mutation (1 = free)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XDICT_SEM:
    ; DCQ     nm_XDICT_SEM, hl_XDICT_SEM
    DQ OFFSET nm_XDICT_SEM, OFFSET hl_XDICT_SEM
    ; DCQ     0
    DQ 0
    ; DCQ     XDICT_SEM, 0
    DQ OFFSET XDICT_SEM, 0
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XDICT_SEM
    DQ OFFSET row_XDICT_SEM
BOOTPTR ENDS
.CODE
XDICT_SEM:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; lea x20, sem_dict
    lea rax, sem_dict
    mov QWORD PTR [r15+160], rax
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_task_dp_bounds:
    ; mov     x10, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+80], rax
    ; cbnz    x10, _tdb_up
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    jne _tdb_up
    ; lea x10, up_var
    lea rax, up_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
_tdb_up:
    ; cbz     x10, _tdb_global
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _tdb_global
    ; ldr     x9, [x10, #TU_DP]
    mov r10, QWORD PTR [r15+80]
    add r10, 108h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+72], rax
    ; cbz     x9, _tdb_global
    mov rax, QWORD PTR [r15+72]
    cmp rax, 0
    je _tdb_global
    ; add     x0, x10, #TU_DP
    mov rax, QWORD PTR [r15+80]
    add rax, 108h
    mov QWORD PTR [r15+0], rax
    ; ldr     x1, [x10, #TU_DLIM]
    mov r10, QWORD PTR [r15+80]
    add r10, 110h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; ldr     x2, [x10, #TU_DBASE]
    mov r10, QWORD PTR [r15+80]
    add r10, 100h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; ret
    jmp QWORD PTR [r15+240]
_tdb_global:
    ; lea x0, here_ptr
    lea rax, here_ptr
    mov QWORD PTR [r15+0], rax
    ; lea x2, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR [r15+16], rax
    ; lea x1, user_dict_size_cell
    lea rax, user_dict_size_cell
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; add     x1, x2, x1
    mov rax, QWORD PTR [r15+16]
    mov rcx, QWORD PTR [r15+8]
    add rax, rcx
    mov QWORD PTR [r15+8], rax
    ; ret
    jmp QWORD PTR [r15+240]
_task_stop_or_abandon:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _task_is_console
    lea rax, xret_33
    mov QWORD PTR [r15+240], rax
    jmp _task_is_console
    xret_33:
    ; cbnz    x0, _tsoa_abandon
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tsoa_abandon
    ; bl      _core_is_worker
    lea rax, xret_34
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_34:
    ; cbnz    x0, _tsoa_worker
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _tsoa_worker
    ; mov     x5, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+40], rax
    ; cbnz    x5, _tsoa_mark
    mov rax, QWORD PTR [r15+40]
    cmp rax, 0
    jne _tsoa_mark
    ; lea x5, up_var
    lea rax, up_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
_tsoa_mark:
    ; str     xzr, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; mov     x6, x19
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r15+48], rax
    ; bl      _task_yield
    lea rax, xret_35
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_35:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _tsoa_switched
    cmp BYTE PTR [r15+249], 0
    je _tsoa_switched
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x19, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+152], rax
_tsoa_abandon:
    ; b       _error_abandon
    jmp _error_abandon
_tsoa_switched:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_tsoa_worker:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; str     xzr, [x27, #TU_STATUS]
    mov r10, QWORD PTR [r15+216]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _core_leave
    jmp _core_leave
_task_require_dict:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _task_is_console
    lea rax, xret_36
    mov QWORD PTR [r15+240], rax
    jmp _task_is_console
    xret_36:
    ; cbnz    x0, _trd_ok
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _trd_ok
    ; mov     x10, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+80], rax
    ; cbnz    x10, _trd_have
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    jne _trd_have
    ; lea x10, up_var
    lea rax, up_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
_trd_have:
    ; cbz     x10, _trd_ok
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _trd_ok
    ; ldr     x9, [x10, #TU_DP]
    mov r10, QWORD PTR [r15+80]
    add r10, 108h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+72], rax
    ; cbnz    x9, _trd_ok
    mov rax, QWORD PTR [r15+72]
    cmp rax, 0
    jne _trd_ok
_trd_none:
    ; lea x0, str_slice_none
    lea rax, str_slice_none
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_37
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_37:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; b       _task_stop_or_abandon
    jmp _task_stop_or_abandon
_trd_ok:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_here_reserve:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; bl      _task_require_dict
    lea rax, xret_38
    mov QWORD PTR [r15+240], rax
    jmp _task_require_dict
    xret_38:
    ; bl      _task_dp_bounds
    lea rax, xret_39
    mov QWORD PTR [r15+240], rax
    jmp _task_dp_bounds
    xret_39:
    ; ldr     x6, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    add rsp, 10h
    ; mov     x5, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+40], rax
    ; ldr     x3, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; add     x4, x3, x6
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+48]
    add rax, rcx
    mov QWORD PTR [r15+32], rax
    ; cmp     x4, x3
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hr_full
    cmp BYTE PTR [r15+250], 0
    je _hr_full
    ; add     x7, x4, #7
    mov rax, QWORD PTR [r15+32]
    add rax, 7
    mov QWORD PTR [r15+56], rax
    ; cmp     x7, x4
    mov rax, QWORD PTR [r15+56]
    mov rcx, QWORD PTR [r15+32]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hr_full
    cmp BYTE PTR [r15+250], 0
    je _hr_full
    ; bic     x4, x7, #7
    mov rax, QWORD PTR [r15+56]
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR [r15+32], rax
    ; cmp     x4, x1
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _hr_full
    cmp BYTE PTR [r15+250], 0
    je xsk_40
    cmp BYTE PTR [r15+249], 0
    je _hr_full
    xsk_40:
    ; cmp     x3, x2
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hr_full
    cmp BYTE PTR [r15+250], 0
    je _hr_full
    ; str     x4, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r10], rax
    ; mov     x0, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_here_reserve_exact:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; bl      _task_require_dict
    lea rax, xret_41
    mov QWORD PTR [r15+240], rax
    jmp _task_require_dict
    xret_41:
    ; bl      _task_dp_bounds
    lea rax, xret_42
    mov QWORD PTR [r15+240], rax
    jmp _task_dp_bounds
    xret_42:
    ; ldr     x6, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    add rsp, 10h
    ; mov     x5, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+40], rax
    ; ldr     x3, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; add     x4, x3, x6
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+48]
    add rax, rcx
    mov QWORD PTR [r15+32], rax
    ; cmp     x4, x3
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hr_full
    cmp BYTE PTR [r15+250], 0
    je _hr_full
    ; cmp     x4, x1
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _hr_full
    cmp BYTE PTR [r15+250], 0
    je xsk_43
    cmp BYTE PTR [r15+249], 0
    je _hr_full
    xsk_43:
    ; cmp     x3, x2
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _hr_full
    cmp BYTE PTR [r15+250], 0
    je _hr_full
    ; str     x4, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r10], rax
    ; mov     x0, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_hr_full:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; lea x0, str_dict_full
    lea rax, str_dict_full
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_44
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_44:
    ; b       _task_stop_or_abandon
    jmp _task_stop_or_abandon
_dict_allot:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; bl      _task_require_dict
    lea rax, xret_45
    mov QWORD PTR [r15+240], rax
    jmp _task_require_dict
    xret_45:
    ; bl      _task_dp_bounds
    lea rax, xret_46
    mov QWORD PTR [r15+240], rax
    jmp _task_dp_bounds
    xret_46:
    ; ldr     x6, [sp]
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; lea x9, here_ptr
    lea rax, here_ptr
    mov QWORD PTR [r15+72], rax
    ; cmp     x0, x9
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+72]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _da_lock
    cmp BYTE PTR [r15+249], 0
    jne _da_lock
    ; mov     x7, #0
    mov rax, 0
    mov QWORD PTR [r15+56], rax
    ; b       _da_have_lock
    jmp _da_have_lock
_da_lock:
    ; stp     x0, x6, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r10+8], rax
    ; stp     x1, x2, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10+8], rax
    ; lea x0, sem_dict
    lea rax, sem_dict
    mov QWORD PTR [r15+0], rax
    ; bl      _core_claim_any
    lea rax, xret_47
    mov QWORD PTR [r15+240], rax
    jmp _core_claim_any
    xret_47:
    ; ldp     x1, x2, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR [r15+16], rcx
    add rsp, 10h
    ; ldp     x0, x6, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+0], rax
    mov QWORD PTR [r15+48], rcx
    add rsp, 10h
    ; mov     x7, #1
    mov rax, 1
    mov QWORD PTR [r15+56], rax
_da_have_lock:
    ; add     sp, sp, #16
    mov rax, rsp
    add rax, 10h
    mov rsp, rax
    ; ldr     x3, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; add     x3, x3, #7
    mov rax, QWORD PTR [r15+24]
    add rax, 7
    mov QWORD PTR [r15+24], rax
    ; bic     x3, x3, #7
    mov rax, QWORD PTR [r15+24]
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR [r15+24], rax
    ; add     x4, x3, x6
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+48]
    add rax, rcx
    mov QWORD PTR [r15+32], rax
    ; cmp     x4, x3
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+24]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _da_fail
    cmp BYTE PTR [r15+250], 0
    je _da_fail
    ; cmp     x4, x1
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _da_fail
    cmp BYTE PTR [r15+250], 0
    je xsk_48
    cmp BYTE PTR [r15+249], 0
    je _da_fail
    xsk_48:
    ; cmp     x3, x2
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _da_fail
    cmp BYTE PTR [r15+250], 0
    je _da_fail
    ; mov     x5, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+40], rax
_da_zero:
    ; str     xzr, [x5], #8
    mov r10, QWORD PTR [r15+40]
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR [r15+40]
    add rax, 8
    mov QWORD PTR [r15+40], rax
    ; subs    x6, x6, #8
    mov rax, QWORD PTR [r15+48]
    sub rax, 8
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+48], rax
    ; b.ne    _da_zero
    cmp BYTE PTR [r15+249], 0
    je _da_zero
    ; str     x4, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r10], rax
    ; mov     x0, x3
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r15+0], rax
    ; cbz     x7, _da_ret
    mov rax, QWORD PTR [r15+56]
    cmp rax, 0
    je _da_ret
    ; str     x0, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; bl      _core_release_dict
    lea rax, xret_49
    mov QWORD PTR [r15+240], rax
    jmp _core_release_dict
    xret_49:
    ; ldr     x0, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    add rsp, 10h
_da_ret:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_da_fail:
    ; cbz     x7, _da_fail_msg
    mov rax, QWORD PTR [r15+56]
    cmp rax, 0
    je _da_fail_msg
    ; bl      _core_release_dict
    lea rax, xret_50
    mov QWORD PTR [r15+240], rax
    jmp _core_release_dict
    xret_50:
_da_fail_msg:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; lea x0, str_allot_over
    lea rax, str_allot_over
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_51
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_51:
    ; b       _task_stop_or_abandon
    jmp _task_stop_or_abandon
_task_park_fail:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x21, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+168], rax
    ; bl      _core_wait_self
    lea rax, xret_52
    mov QWORD PTR [r15+240], rax
    jmp _core_wait_self
    xret_52:
    ; cbz     x0, _tpf_coop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _tpf_coop
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_tpf_coop:
    ; bl      _task_can_switch
    lea rax, xret_53
    mov QWORD PTR [r15+240], rax
    jmp _task_can_switch
    xret_53:
    ; cbz     x0, _tpf_noswitch
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _tpf_noswitch
    ; lea x5, up_var
    lea rax, up_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; str     x19, [x5, #TU_RESUME]
    mov r10, QWORD PTR [r15+40]
    add r10, 50h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; mov     x19, x21
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r15+152], rax
    ; bl      _task_yield
    lea rax, xret_54
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_54:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _tpf_stayed
    cmp BYTE PTR [r15+249], 0
    jne _tpf_stayed
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_tpf_stayed:
    ; ldr     x19, [x5, #TU_RESUME]
    mov r10, QWORD PTR [r15+40]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
_tpf_noswitch:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
BWSTR SEGMENT ALIGN(1) READ
nm_XMAILBOX:
    ; DCB "MAILBOX", 0
    DB "MAILBOX", 0
hl_XMAILBOX:
    ; DCB "MAILBOX ( -- addr ) allot a value and a full/empty pair", 0
    DB "MAILBOX ( -- addr ) allot a value and a full/empty pair", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMAILBOX:
    ; DCQ     nm_XMAILBOX, hl_XMAILBOX
    DQ OFFSET nm_XMAILBOX, OFFSET hl_XMAILBOX
    ; DCQ     0
    DQ 0
    ; DCQ     XMAILBOX, XMAILBOX_END
    DQ OFFSET XMAILBOX, OFFSET XMAILBOX_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMAILBOX
    DQ OFFSET row_XMAILBOX
BOOTPTR ENDS
.CODE
XMAILBOX:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x0, #MB_BYTES
    mov rax, 18h
    mov QWORD PTR [r15+0], rax
    ; bl      _dict_allot
    lea rax, xret_55
    mov QWORD PTR [r15+240], rax
    jmp _dict_allot
    xret_55:
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #MB_EMPTY]
    mov r10, QWORD PTR [r15+0]
    add r10, 10h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
XMAILBOX_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XMBOX_PUT:
    ; DCB ">MBOX", 0
    DB ">MBOX", 0
hl_XMBOX_PUT:
    ; DCB ">MBOX ( n addr -- ) store n when the mailbox is empty, then signal full", 0
    DB ">MBOX ( n addr -- ) store n when the mailbox is empty, then signal full", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMBOX_PUT:
    ; DCQ     nm_XMBOX_PUT, hl_XMBOX_PUT
    DQ OFFSET nm_XMBOX_PUT, OFFSET hl_XMBOX_PUT
    ; DCQ     0
    DQ 0
    ; DCQ     XMBOX_PUT, XMBOX_PUT_END
    DQ OFFSET XMBOX_PUT, OFFSET XMBOX_PUT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMBOX_PUT
    DQ OFFSET row_XMBOX_PUT
BOOTPTR ENDS
.CODE
XMBOX_PUT_RETRY:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x19, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; b       XMBOX_PUT
    jmp XMBOX_PUT
XMBOX_PUT:
    ; add     x0, x20, #MB_EMPTY
    mov rax, QWORD PTR [r15+160]
    add rax, 10h
    mov QWORD PTR [r15+0], rax
_mb_put_try:
    ; ldaxr   x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR arm_excl_addr, r10
    mov QWORD PTR arm_excl_val, rax
    mov QWORD PTR arm_excl, 1
    ; cbz     x1, _mb_put_busy
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _mb_put_busy
    ; stlxr   w2, xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    cmp QWORD PTR arm_excl, 0
    je xxl_56
    cmp r10, QWORD PTR arm_excl_addr
    jne xxl_56
    mov rax, QWORD PTR arm_excl_val
    xor ecx, ecx
    lock cmpxchg QWORD PTR [r10], rcx
    mov QWORD PTR arm_excl, 0
    jne xxl_56
    xor eax, eax
    jmp xxl_57
    xxl_56:
    mov QWORD PTR arm_excl, 0
    mov eax, 1
    xxl_57:
    mov QWORD PTR [r15+16], rax
    ; cbnz    w2, _mb_put_try
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _mb_put_try
    ; ldr     x1, [x22]
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x20, #MB_VALUE]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; add     x0, x20, #MB_FULL
    mov rax, QWORD PTR [r15+160]
    add rax, 8
    mov QWORD PTR [r15+0], rax
    ; stlr    x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; add     x22, x22, #8
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; bl      _core_wake
    lea rax, xret_58
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_58:
    ; b       XMBOX_PUT_END
    jmp XMBOX_PUT_END
_mb_put_busy:
    ; clrex
    mov QWORD PTR arm_excl, 0
    ; lea x6, mbox_put_thread
    lea rax, mbox_put_thread
    mov QWORD PTR [r15+48], rax
    ; bl      _task_park_fail
    lea rax, xret_59
    mov QWORD PTR [r15+240], rax
    jmp _task_park_fail
    xret_59:
    ; cbnz    x0, XMBOX_PUT
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne XMBOX_PUT
    ; add     x22, x22, #8
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; lea x0, str_mbox_put_stuck
    lea rax, str_mbox_put_stuck
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_60
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_60:
XMBOX_PUT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XMBOX_GET:
    ; DCB "MBOX>", 0
    DB "MBOX>", 0
hl_XMBOX_GET:
    ; DCB "MBOX> ( addr -- n ) wait until full, read n, then signal empty", 0
    DB "MBOX> ( addr -- n ) wait until full, read n, then signal empty", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XMBOX_GET:
    ; DCQ     nm_XMBOX_GET, hl_XMBOX_GET
    DQ OFFSET nm_XMBOX_GET, OFFSET hl_XMBOX_GET
    ; DCQ     0
    DQ 0
    ; DCQ     XMBOX_GET, XMBOX_GET_END
    DQ OFFSET XMBOX_GET, OFFSET XMBOX_GET_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XMBOX_GET
    DQ OFFSET row_XMBOX_GET
BOOTPTR ENDS
.CODE
XMBOX_GET_RETRY:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x19, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; b       XMBOX_GET
    jmp XMBOX_GET
XMBOX_GET:
    ; add     x0, x20, #MB_FULL
    mov rax, QWORD PTR [r15+160]
    add rax, 8
    mov QWORD PTR [r15+0], rax
_mb_get_try:
    ; ldaxr   x1, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR arm_excl_addr, r10
    mov QWORD PTR arm_excl_val, rax
    mov QWORD PTR arm_excl, 1
    ; cbz     x1, _mb_get_busy
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _mb_get_busy
    ; stlxr   w2, xzr, [x0]
    mov r10, QWORD PTR [r15+0]
    cmp QWORD PTR arm_excl, 0
    je xxl_61
    cmp r10, QWORD PTR arm_excl_addr
    jne xxl_61
    mov rax, QWORD PTR arm_excl_val
    xor ecx, ecx
    lock cmpxchg QWORD PTR [r10], rcx
    mov QWORD PTR arm_excl, 0
    jne xxl_61
    xor eax, eax
    jmp xxl_62
    xxl_61:
    mov QWORD PTR arm_excl, 0
    mov eax, 1
    xxl_62:
    mov QWORD PTR [r15+16], rax
    ; cbnz    w2, _mb_get_try
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _mb_get_try
    ; ldr     x1, [x20, #MB_VALUE]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; mov     x3, #1
    mov rax, 1
    mov QWORD PTR [r15+24], rax
    ; add     x0, x20, #MB_EMPTY
    mov rax, QWORD PTR [r15+160]
    add rax, 10h
    mov QWORD PTR [r15+0], rax
    ; stlr    x3, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; mov     x20, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+160], rax
    ; bl      _core_wake
    lea rax, xret_63
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_63:
    ; b       XMBOX_GET_END
    jmp XMBOX_GET_END
_mb_get_busy:
    ; clrex
    mov QWORD PTR arm_excl, 0
    ; lea x6, mbox_get_thread
    lea rax, mbox_get_thread
    mov QWORD PTR [r15+48], rax
    ; bl      _task_park_fail
    lea rax, xret_64
    mov QWORD PTR [r15+240], rax
    jmp _task_park_fail
    xret_64:
    ; cbnz    x0, XMBOX_GET
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne XMBOX_GET
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
    ; lea x0, str_mbox_get_stuck
    lea rax, str_mbox_get_stuck
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_65
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_65:
XMBOX_GET_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XQUEUE:
    ; DCB "QUEUE", 0
    DB "QUEUE", 0
hl_XQUEUE:
    ; DCB "QUEUE ( n -- addr ) allot a fixed ring of n slots (n >= 2)", 0
    DB "QUEUE ( n -- addr ) allot a fixed ring of n slots (n >= 2)", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQUEUE:
    ; DCQ     nm_XQUEUE, hl_XQUEUE
    DQ OFFSET nm_XQUEUE, OFFSET hl_XQUEUE
    ; DCQ     0
    DQ 0
    ; DCQ     XQUEUE, XQUEUE_END
    DQ OFFSET XQUEUE, OFFSET XQUEUE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQUEUE
    DQ OFFSET row_XQUEUE
BOOTPTR ENDS
.CODE
XQUEUE:
    ; cmp     x20, #2
    mov rax, QWORD PTR [r15+160]
    cmp rax, 2
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lt    _queue_bad_n
    mov r11b, BYTE PTR [r15+248]
    cmp r11b, BYTE PTR [r15+251]
    jne _queue_bad_n
    ; lsr     x1, x20, #61
    mov rax, QWORD PTR [r15+160]
    shr rax, 61
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, _queue_overflow
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne _queue_overflow
    ; lsl     x0, x20, #3
    mov rax, QWORD PTR [r15+160]
    shl rax, 3
    mov QWORD PTR [r15+0], rax
    ; adds    x0, x0, #Q_SLOTS
    mov rax, QWORD PTR [r15+0]
    add rax, 18h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    mov QWORD PTR [r15+0], rax
    ; b.cs    _queue_overflow
    cmp BYTE PTR [r15+250], 0
    jne _queue_overflow
    ; mov     x21, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+168], rax
    ; bl      _dict_allot
    lea rax, xret_66
    mov QWORD PTR [r15+240], rax
    jmp _dict_allot
    xret_66:
    ; str     x21, [x0, #Q_CAP]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r10], rax
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
    ; b       XQUEUE_END
    jmp XQUEUE_END
_queue_bad_n:
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; lea x0, str_queue_n
    lea rax, str_queue_n
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_67
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_67:
    ; b       XQUEUE_END
    jmp XQUEUE_END
_queue_overflow:
    ; lea x0, str_allot_over
    lea rax, str_allot_over
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_68
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_68:
    ; b       _error_abandon
    jmp _error_abandon
XQUEUE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XQPUT:
    ; DCB ">Q", 0
    DB ">Q", 0
hl_XQPUT:
    ; DCB ">Q ( n addr -- ) write n into the ring, then publish the tail", 0
    DB ">Q ( n addr -- ) write n into the ring, then publish the tail", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQPUT:
    ; DCQ     nm_XQPUT, hl_XQPUT
    DQ OFFSET nm_XQPUT, OFFSET hl_XQPUT
    ; DCQ     0
    DQ 0
    ; DCQ     XQPUT, XQPUT_END
    DQ OFFSET XQPUT, OFFSET XQPUT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQPUT
    DQ OFFSET row_XQPUT
BOOTPTR ENDS
.CODE
XQPUT_RETRY:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x19, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; b       XQPUT
    jmp XQPUT
XQPUT:
    ; ldr     x1, [x20, #Q_CAP]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; ldr     x3, [x20, #Q_TAIL]
    mov r10, QWORD PTR [r15+160]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; add     x0, x20, #Q_HEAD
    mov rax, QWORD PTR [r15+160]
    add rax, 8
    mov QWORD PTR [r15+0], rax
    ; ldar    x4, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; add     x5, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+40], rax
    ; cmp     x5, x1
    mov rax, QWORD PTR [r15+40]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _qput_nowrap
    cmp BYTE PTR [r15+250], 0
    je _qput_nowrap
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
_qput_nowrap:
    ; cmp     x5, x4
    mov rax, QWORD PTR [r15+40]
    mov rcx, QWORD PTR [r15+32]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _qput_full
    cmp BYTE PTR [r15+249], 0
    jne _qput_full
    ; add     x0, x20, #Q_SLOTS
    mov rax, QWORD PTR [r15+160]
    add rax, 18h
    mov QWORD PTR [r15+0], rax
    ; lsl     x4, x3, #3
    mov rax, QWORD PTR [r15+24]
    shl rax, 3
    mov QWORD PTR [r15+32], rax
    ; ldr     x1, [x22]
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, x4]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+32]
    add r10, rax
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; add     x0, x20, #Q_TAIL
    mov rax, QWORD PTR [r15+160]
    add rax, 10h
    mov QWORD PTR [r15+0], rax
    ; stlr    x5, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x22, x22, #8
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; bl      _core_wake
    lea rax, xret_69
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_69:
    ; b       XQPUT_END
    jmp XQPUT_END
_qput_full:
    ; lea x6, qput_thread
    lea rax, qput_thread
    mov QWORD PTR [r15+48], rax
    ; bl      _task_park_fail
    lea rax, xret_70
    mov QWORD PTR [r15+240], rax
    jmp _task_park_fail
    xret_70:
    ; cbnz    x0, XQPUT
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne XQPUT
    ; add     x22, x22, #8
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; lea x0, str_qput_stuck
    lea rax, str_qput_stuck
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_71
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_71:
XQPUT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XQGET:
    ; DCB "Q>", 0
    DB "Q>", 0
hl_XQGET:
    ; DCB "Q> ( addr -- n ) acquire the tail, read n, then publish the head", 0
    DB "Q> ( addr -- n ) acquire the tail, read n, then publish the head", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQGET:
    ; DCQ     nm_XQGET, hl_XQGET
    DQ OFFSET nm_XQGET, OFFSET hl_XQGET
    ; DCQ     0
    DQ 0
    ; DCQ     XQGET, XQGET_END
    DQ OFFSET XQGET, OFFSET XQGET_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQGET
    DQ OFFSET row_XQGET
BOOTPTR ENDS
.CODE
XQGET_RETRY:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; ldr     x19, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; b       XQGET
    jmp XQGET
XQGET:
    ; ldr     x1, [x20, #Q_CAP]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; ldr     x3, [x20, #Q_HEAD]
    mov r10, QWORD PTR [r15+160]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; add     x0, x20, #Q_TAIL
    mov rax, QWORD PTR [r15+160]
    add rax, 10h
    mov QWORD PTR [r15+0], rax
    ; ldar    x4, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; cmp     x3, x4
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+32]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _qget_empty
    cmp BYTE PTR [r15+249], 0
    jne _qget_empty
    ; add     x0, x20, #Q_SLOTS
    mov rax, QWORD PTR [r15+160]
    add rax, 18h
    mov QWORD PTR [r15+0], rax
    ; lsl     x5, x3, #3
    mov rax, QWORD PTR [r15+24]
    shl rax, 3
    mov QWORD PTR [r15+40], rax
    ; ldr     x6, [x0, x5]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+40]
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; add     x5, x3, #1
    mov rax, QWORD PTR [r15+24]
    add rax, 1
    mov QWORD PTR [r15+40], rax
    ; cmp     x5, x1
    mov rax, QWORD PTR [r15+40]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _qget_nowrap
    cmp BYTE PTR [r15+250], 0
    je _qget_nowrap
    ; mov     x5, #0
    mov rax, 0
    mov QWORD PTR [r15+40], rax
_qget_nowrap:
    ; add     x0, x20, #Q_HEAD
    mov rax, QWORD PTR [r15+160]
    add rax, 8
    mov QWORD PTR [r15+0], rax
    ; stlr    x5, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; mov     x20, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+160], rax
    ; bl      _core_wake
    lea rax, xret_72
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_72:
    ; b       XQGET_END
    jmp XQGET_END
_qget_empty:
    ; lea x6, qget_thread
    lea rax, qget_thread
    mov QWORD PTR [r15+48], rax
    ; bl      _task_park_fail
    lea rax, xret_73
    mov QWORD PTR [r15+240], rax
    jmp _task_park_fail
    xret_73:
    ; cbnz    x0, XQGET
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne XQGET
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
    ; lea x0, str_qget_stuck
    lea rax, str_qget_stuck
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_74
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_74:
XQGET_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XQDEPTH:
    ; DCB "Q-DEPTH", 0
    DB "Q-DEPTH", 0
hl_XQDEPTH:
    ; DCB "Q-DEPTH ( addr -- n ) cells waiting in a ring", 0
    DB "Q-DEPTH ( addr -- n ) cells waiting in a ring", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XQDEPTH:
    ; DCQ     nm_XQDEPTH, hl_XQDEPTH
    DQ OFFSET nm_XQDEPTH, OFFSET hl_XQDEPTH
    ; DCQ     0
    DQ 0
    ; DCQ     XQDEPTH, XQDEPTH_END
    DQ OFFSET XQDEPTH, OFFSET XQDEPTH_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XQDEPTH
    DQ OFFSET row_XQDEPTH
BOOTPTR ENDS
.CODE
XQDEPTH:
    ; ldr     x1, [x20, #Q_CAP]
    mov r10, QWORD PTR [r15+160]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, _qd_zero
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _qd_zero
    ; add     x0, x20, #Q_HEAD
    mov rax, QWORD PTR [r15+160]
    add rax, 8
    mov QWORD PTR [r15+0], rax
    ; ldar    x3, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; add     x0, x20, #Q_TAIL
    mov rax, QWORD PTR [r15+160]
    add rax, 10h
    mov QWORD PTR [r15+0], rax
    ; ldar    x4, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+32], rax
    ; sub     x0, x4, x3
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+24]
    sub rax, rcx
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, #0
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ge    _qd_pos
    mov r11b, BYTE PTR [r15+248]
    cmp r11b, BYTE PTR [r15+251]
    je _qd_pos
    ; add     x0, x0, x1
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+8]
    add rax, rcx
    mov QWORD PTR [r15+0], rax
_qd_pos:
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
    ; b       XQDEPTH_END
    jmp XQDEPTH_END
_qd_zero:
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
XQDEPTH_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XCONSOLE_Q:
    ; DCB "(CONSOLE?)", 0
    DB "(CONSOLE?)", 0
hl_XCONSOLE_Q:
    ; DCB "(CONSOLE?) ( -- flag ) true when the running task is the console", 0
    DB "(CONSOLE?) ( -- flag ) true when the running task is the console", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XCONSOLE_Q:
    ; DCQ     nm_XCONSOLE_Q, hl_XCONSOLE_Q
    DQ OFFSET nm_XCONSOLE_Q, OFFSET hl_XCONSOLE_Q
    ; DCQ     0
    DQ 0
    ; DCQ     XCONSOLE_Q, XCONSOLE_Q_END
    DQ OFFSET XCONSOLE_Q, OFFSET XCONSOLE_Q_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XCONSOLE_Q
    DQ OFFSET row_XCONSOLE_Q
BOOTPTR ENDS
.CODE
XCONSOLE_Q:
    ; bl      _task_is_console
    lea rax, xret_75
    mov QWORD PTR [r15+240], rax
    jmp _task_is_console
    xret_75:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x20, #-1
    mov rax, -1
    mov QWORD PTR [r15+160], rax
    ; cbnz    x0, XCONSOLE_Q_END
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne XCONSOLE_Q_END
    ; mov     x20, #0
    mov rax, 0
    mov QWORD PTR [r15+160], rax
XCONSOLE_Q_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSTOP:
    ; DCB "STOP", 0
    DB "STOP", 0
hl_XSTOP:
    ; DCB "STOP ( -- ) sleep the running task and yield", 0
    DB "STOP ( -- ) sleep the running task and yield", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSTOP:
    ; DCQ     nm_XSTOP, hl_XSTOP
    DQ OFFSET nm_XSTOP, OFFSET hl_XSTOP
    ; DCQ     0
    DQ 0
    ; DCQ     XSTOP, XSTOP_END
    DQ OFFSET XSTOP, OFFSET XSTOP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSTOP
    DQ OFFSET row_XSTOP
BOOTPTR ENDS
.CODE
XSTOP:
    ; bl      _core_is_worker
    lea rax, xret_76
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_76:
    ; cbz     x0, _stop_coop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _stop_coop
    ; str     xzr, [x27, #TU_STATUS]
    mov r10, QWORD PTR [r15+216]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _core_leave
    jmp _core_leave
_stop_coop:
    ; lea x5, up_var
    lea rax, up_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x5, x1
    mov rax, QWORD PTR [r15+40]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _stop_console
    cmp BYTE PTR [r15+249], 0
    jne _stop_console
    ; mov     x6, x19
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r15+48], rax
    ; str     xzr, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; bl      _task_yield
    lea rax, xret_77
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_77:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    XSTOP_END
    cmp BYTE PTR [r15+249], 0
    je XSTOP_END
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x19, x6
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r15+152], rax
    ; b       XSTOP_END
    jmp XSTOP_END
_stop_console:
    ; lea x0, str_stop_console
    lea rax, str_stop_console
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_78
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_78:
XSTOP_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSLEEP:
    ; DCB "SLEEP", 0
    DB "SLEEP", 0
hl_XSLEEP:
    ; DCB "SLEEP ( task -- ) mark a task asleep; yield if it is current", 0
    DB "SLEEP ( task -- ) mark a task asleep; yield if it is current", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSLEEP:
    ; DCQ     nm_XSLEEP, hl_XSLEEP
    DQ OFFSET nm_XSLEEP, OFFSET hl_XSLEEP
    ; DCQ     0
    DQ 0
    ; DCQ     XSLEEP, XSLEEP_END
    DQ OFFSET XSLEEP, OFFSET XSLEEP_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSLEEP
    DQ OFFSET row_XSLEEP
BOOTPTR ENDS
.CODE
XSLEEP:
    ; lea x1, up_var
    lea rax, up_var
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cmp     x20, x1
    mov rax, QWORD PTR [r15+160]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _sleep_self
    cmp BYTE PTR [r15+249], 0
    jne _sleep_self
    ; mov     x5, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+40], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; str     xzr, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; b       XSLEEP_END
    jmp XSLEEP_END
_sleep_self:
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x20, x1
    mov rax, QWORD PTR [r15+160]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _sleep_self_ok
    cmp BYTE PTR [r15+249], 0
    je _sleep_self_ok
    ; bl      _task_other_awake
    lea rax, xret_79
    mov QWORD PTR [r15+240], rax
    jmp _task_other_awake
    xret_79:
    ; cbnz    x0, _sleep_self_ok
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _sleep_self_ok
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; lea x0, str_sleep_only
    lea rax, str_sleep_only
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_80
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_80:
    ; b       XSLEEP_END
    jmp XSLEEP_END
_sleep_self_ok:
    ; mov     x5, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+40], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; str     xzr, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; bl      _task_yield
    lea rax, xret_81
    mov QWORD PTR [r15+240], rax
    jmp _task_yield
    xret_81:
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cmp     x0, x5
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+40]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    XSLEEP_END
    cmp BYTE PTR [r15+249], 0
    je XSLEEP_END
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
XSLEEP_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XWAKE:
    ; DCB "WAKE", 0
    DB "WAKE", 0
hl_XWAKE:
    ; DCB "WAKE ( task -- ) mark a task awake", 0
    DB "WAKE ( task -- ) mark a task awake", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XWAKE:
    ; DCQ     nm_XWAKE, hl_XWAKE
    DQ OFFSET nm_XWAKE, OFFSET hl_XWAKE
    ; DCQ     0
    DQ 0
    ; DCQ     XWAKE, XWAKE_END
    DQ OFFSET XWAKE, OFFSET XWAKE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XWAKE
    DQ OFFSET row_XWAKE
BOOTPTR ENDS
.CODE
XWAKE:
    ; mov     x5, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+40], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x5, #TU_STATUS]
    mov r10, QWORD PTR [r15+40]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
XWAKE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XACTIVATE:
    ; DCB "ACTIVATE", 0
    DB "ACTIVATE", 0
hl_XACTIVATE:
    ; DCB "ACTIVATE ( task -- ) run the following colon body as that task", 0
    DB "ACTIVATE ( task -- ) run the following colon body as that task", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XACTIVATE:
    ; DCQ     nm_XACTIVATE, hl_XACTIVATE
    DQ OFFSET nm_XACTIVATE, OFFSET hl_XACTIVATE
    ; DCQ     0
    DQ 0
    ; DCQ     XACTIVATE, XACTIVATE_END
    DQ OFFSET XACTIVATE, OFFSET XACTIVATE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XACTIVATE
    DQ OFFSET row_XACTIVATE
BOOTPTR ENDS
.CODE
XACTIVATE:
    ; lea x1, restart_cell
    lea rax, restart_cell
    mov QWORD PTR [r15+8], rax
    ; cmp     x19, x1
    mov rax, QWORD PTR [r15+152]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _act_interp
    cmp BYTE PTR [r15+249], 0
    jne _act_interp
    ; lea x1, up_var
    lea rax, up_var
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cmp     x20, x1
    mov rax, QWORD PTR [r15+160]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _act_self
    cmp BYTE PTR [r15+249], 0
    jne _act_self
    ; mov     x0, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+0], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; str     x19, [x0, #TU_IP]
    mov r10, QWORD PTR [r15+0]
    add r10, 10h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; str     xzr, [x0, #TU_TOS]
    mov r10, QWORD PTR [r15+0]
    add r10, 18h
    mov QWORD PTR [r10], 0
    ; ldr     x1, [x0, #TU_S0]
    mov r10, QWORD PTR [r15+0]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_DSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 20h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; ldr     x1, [x0, #TU_R0]
    mov r10, QWORD PTR [r15+0]
    add r10, 38h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; sub     x2, x1, #8
    mov rax, QWORD PTR [r15+8]
    sub rax, 8
    mov QWORD PTR [r15+16], rax
    ; lea x3, task_stop_thread
    lea rax, task_stop_thread
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; str     x2, [x0, #TU_RSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 28h
    mov rax, QWORD PTR [r15+16]
    mov QWORD PTR [r10], rax
    ; lea x1, base_var
    lea rax, base_var
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_BASE]
    mov r10, QWORD PTR [r15+0]
    add r10, 40h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; str     xzr, [x0, #TU_STATE]
    mov r10, QWORD PTR [r15+0]
    add r10, 48h
    mov QWORD PTR [r10], 0
    ; mov     x1, #TU_SRC_ADDR
    mov rax, 68h
    mov QWORD PTR [r15+8], rax
_act_clr_src:
    ; str     xzr, [x0, x1]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+8]
    add r10, rax
    mov QWORD PTR [r10], 0
    ; add     x1, x1, #8
    mov rax, QWORD PTR [r15+8]
    add rax, 8
    mov QWORD PTR [r15+8], rax
    ; cmp     x1, #TU_WORD_PTR
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0D8h
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _act_clr_src
    cmp BYTE PTR [r15+250], 0
    je _act_clr_src
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_STATUS]
    mov r10, QWORD PTR [r15+0]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; ldr     x19, [x23], #8
    mov r10, QWORD PTR [r15+184]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    mov rax, QWORD PTR [r15+184]
    add rax, 8
    mov QWORD PTR [r15+184], rax
    ; lea x1, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, XACTIVATE_END
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je XACTIVATE_END
    ; lea x1, core_schedule_hook
    lea rax, core_schedule_hook
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbz     x1, XACTIVATE_END
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je XACTIVATE_END
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
    ; b       XACTIVATE_END
    jmp XACTIVATE_END
_act_interp:
    ; lea x0, str_act_interp
    lea rax, str_act_interp
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_82
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_82:
    ; b       _error_abandon
    jmp _error_abandon
_act_self:
    ; lea x0, str_act_self
    lea rax, str_act_self
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_83
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_83:
    ; b       _error_abandon
    jmp _error_abandon
XACTIVATE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XTASK_INIT:
    ; DCB "(TASK-INIT)", 0
    DB "(TASK-INIT)", 0
hl_XTASK_INIT:
    ; DCB "(TASK-INIT) ( -- ) allot user area and stacks at HERE and link the task", 0
    DB "(TASK-INIT) ( -- ) allot user area and stacks at HERE and link the task", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XTASK_INIT:
    ; DCQ     nm_XTASK_INIT, hl_XTASK_INIT
    DQ OFFSET nm_XTASK_INIT, OFFSET hl_XTASK_INIT
    ; DCQ     0
    DQ 0
    ; DCQ     XTASK_INIT, XTASK_INIT_END
    DQ OFFSET XTASK_INIT, OFFSET XTASK_INIT_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XTASK_INIT
    DQ OFFSET row_XTASK_INIT
BOOTPTR ENDS
.CODE
XTASK_INIT:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _task_require_dict
    lea rax, xret_84
    mov QWORD PTR [r15+240], rax
    jmp _task_require_dict
    xret_84:
    ; bl      _task_dp_bounds
    lea rax, xret_85
    mov QWORD PTR [r15+240], rax
    jmp _task_dp_bounds
    xret_85:
    ; mov     x7, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+56], rax
    ; ldr     x0, [x7]
    mov r10, QWORD PTR [r15+56]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; mov     x6, #TASK_ALLOT
    mov rax, 2DD8h
    mov QWORD PTR [r15+48], rax
    ; add     x4, x0, x6
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+48]
    add rax, rcx
    mov QWORD PTR [r15+32], rax
    ; cmp     x4, x0
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+0]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _task_allot_fail
    cmp BYTE PTR [r15+250], 0
    je _task_allot_fail
    ; cmp     x4, x1
    mov rax, QWORD PTR [r15+32]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _task_allot_fail
    cmp BYTE PTR [r15+250], 0
    je xsk_86
    cmp BYTE PTR [r15+249], 0
    je _task_allot_fail
    xsk_86:
    ; mov     x5, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+40], rax
_task_zero:
    ; str     xzr, [x5], #8
    mov r10, QWORD PTR [r15+40]
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR [r15+40]
    add rax, 8
    mov QWORD PTR [r15+40], rax
    ; subs    x6, x6, #8
    mov rax, QWORD PTR [r15+48]
    sub rax, 8
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+48], rax
    ; b.ne    _task_zero
    cmp BYTE PTR [r15+249], 0
    je _task_zero
    ; str     x4, [x7]
    mov r10, QWORD PTR [r15+56]
    mov rax, QWORD PTR [r15+32]
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; add     x5, x0, #TU_BYTES
    mov rax, QWORD PTR [r15+0]
    add rax, 118h
    mov QWORD PTR [r15+40], rax
    ; add     x5, x5, #1, lsl #12
    mov rax, QWORD PTR [r15+40]
    add rax, 1000h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_S0]
    mov r10, QWORD PTR [r15+0]
    add r10, 30h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; str     x5, [x0, #TU_DSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 20h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x5, x5, #1, lsl #12
    mov rax, QWORD PTR [r15+40]
    add rax, 1000h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_R0]
    mov r10, QWORD PTR [r15+0]
    add r10, 38h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; str     x5, [x0, #TU_RSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 28h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; str     x5, [x0, #TU_WORD_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0D8h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x5, x5, #TASK_WORD_BYTES
    mov rax, QWORD PTR [r15+40]
    add rax, 200h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_PAD_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0E0h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x5, x5, #TASK_PAD_BYTES
    mov rax, QWORD PTR [r15+40]
    add rax, 400h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_INPUT_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0E8h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x5, x5, #TASK_INPUT_BYTES
    mov rax, QWORD PTR [r15+40]
    add rax, 400h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_SSTK_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0F0h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x5, x5, #TASK_SRCSTK_BYTES
    mov rax, QWORD PTR [r15+40]
    add rax, 280h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_EVALSTK_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0F8h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; lea x5, base_var
    lea rax, base_var
    mov QWORD PTR [r15+40], rax
    ; ldr     x5, [x5]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_BASE]
    mov r10, QWORD PTR [r15+0]
    add r10, 40h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; lea x5, XKEY_RETRY
    lea rax, XKEY_RETRY
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_RETRY_XT]
    mov r10, QWORD PTR [r15+0]
    add r10, 58h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; add     x5, x0, #TU_RETRY_XT
    mov rax, QWORD PTR [r15+0]
    add rax, 58h
    mov QWORD PTR [r15+40], rax
    ; str     x5, [x0, #TU_RETRY_LIST]
    mov r10, QWORD PTR [r15+0]
    add r10, 60h
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r10], rax
    ; lea x5, console_task
    lea rax, console_task
    mov QWORD PTR [r15+40], rax
    ; ldr     x6, [x5, #TU_LINK]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+48], rax
    ; cbnz    x6, _task_link
    mov rax, QWORD PTR [r15+48]
    cmp rax, 0
    jne _task_link
    ; mov     x6, x5
    mov rax, QWORD PTR [r15+40]
    mov QWORD PTR [r15+48], rax
_task_link:
    ; str     x6, [x0, #TU_LINK]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+48]
    mov QWORD PTR [r10], rax
    ; str     x0, [x5, #TU_LINK]
    mov r10, QWORD PTR [r15+40]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; b       XTASK_INIT_END
    jmp XTASK_INIT_END
_task_allot_fail:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; lea x0, str_allot_over
    lea rax, str_allot_over
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_87
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_87:
    ; b       _task_stop_or_abandon
    jmp _task_stop_or_abandon
XTASK_INIT_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
BWSTR SEGMENT ALIGN(1) READ
nm_XSLICE:
    ; DCB "SLICE", 0
    DB "SLICE", 0
hl_XSLICE:
    ; DCB "SLICE ( n task -- ) reserve n bytes as that task's private dictionary", 0
    DB "SLICE ( n task -- ) reserve n bytes as that task's private dictionary", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSLICE:
    ; DCQ     nm_XSLICE, hl_XSLICE
    DQ OFFSET nm_XSLICE, OFFSET hl_XSLICE
    ; DCQ     0
    DQ 0
    ; DCQ     XSLICE, XSLICE_END
    DQ OFFSET XSLICE, OFFSET XSLICE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSLICE
    DQ OFFSET row_XSLICE
BOOTPTR ENDS
.CODE
XSLICE:
    ; lea x1, console_task
    lea rax, console_task
    mov QWORD PTR [r15+8], rax
    ; cmp     x27, x1
    mov rax, QWORD PTR [r15+216]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _xslice_ok
    cmp BYTE PTR [r15+249], 0
    jne _xslice_ok
    ; lea x0, str_slice_console
    lea rax, str_slice_console
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_88
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_88:
    ; b       XSTOP
    jmp XSTOP
_xslice_ok:
    ; mov     x9, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+72], rax
    ; ldr     x8, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+64], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; tst     x9, #7
    mov rax, QWORD PTR [r15+72]
    test rax, 7
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setc BYTE PTR [r15+250]
    ; b.ne    _xslice_bad
    cmp BYTE PTR [r15+249], 0
    je _xslice_bad
    ; cmp     x9, x1
    mov rax, QWORD PTR [r15+72]
    mov rcx, QWORD PTR [r15+8]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _xslice_bad
    cmp BYTE PTR [r15+249], 0
    jne _xslice_bad
    ; lea x2, user_dict_area
    lea rax, user_dict_area
    mov QWORD PTR [r15+16], rax
    ; cmp     x9, x2
    mov rax, QWORD PTR [r15+72]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _xslice_bad
    cmp BYTE PTR [r15+250], 0
    je _xslice_bad
    ; lea x2, here_ptr
    lea rax, here_ptr
    mov QWORD PTR [r15+16], rax
    ; ldr     x2, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cmp     x9, x2
    mov rax, QWORD PTR [r15+72]
    mov rcx, QWORD PTR [r15+16]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _xslice_bad
    cmp BYTE PTR [r15+250], 0
    jne _xslice_bad
    ; ldr     x2, [x9, #TU_STATUS]
    mov r10, QWORD PTR [r15+72]
    add r10, 8
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbnz    x2, _xslice_bad
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _xslice_bad
    ; ldr     x2, [x9, #TU_DP]
    mov r10, QWORD PTR [r15+72]
    add r10, 108h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+16], rax
    ; cbnz    x2, _xslice_bad
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0
    jne _xslice_bad
    ; cmp     x8, #1
    mov rax, QWORD PTR [r15+64]
    cmp rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lt    _xslice_bad
    mov r11b, BYTE PTR [r15+248]
    cmp r11b, BYTE PTR [r15+251]
    jne _xslice_bad
    ; add     x8, x8, #7
    mov rax, QWORD PTR [r15+64]
    add rax, 7
    mov QWORD PTR [r15+64], rax
    ; bic     x8, x8, #7
    mov rax, QWORD PTR [r15+64]
    mov rcx, 7
    not rcx
    and rax, rcx
    mov QWORD PTR [r15+64], rax
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; stp     x8, x9, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+64]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+72]
    mov QWORD PTR [r10+8], rax
    ; mov     x0, x8
    mov rax, QWORD PTR [r15+64]
    mov QWORD PTR [r15+0], rax
    ; bl      _dict_allot
    lea rax, xret_89
    mov QWORD PTR [r15+240], rax
    jmp _dict_allot
    xret_89:
    ; ldp     x8, x9, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+64], rax
    mov QWORD PTR [r15+72], rcx
    add rsp, 10h
    ; str     x0, [x9, #TU_DBASE]
    mov r10, QWORD PTR [r15+72]
    add r10, 100h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; str     x0, [x9, #TU_DP]
    mov r10, QWORD PTR [r15+72]
    add r10, 108h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; add     x1, x0, x8
    mov rax, QWORD PTR [r15+0]
    mov rcx, QWORD PTR [r15+64]
    add rax, rcx
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x9, #TU_DLIM]
    mov r10, QWORD PTR [r15+72]
    add r10, 110h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_xslice_bad:
    ; lea x0, str_slice_bad
    lea rax, str_slice_bad
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_90
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_90:
    ; b       _error_abandon
    jmp _error_abandon
XSLICE_END:
_task_forget_cut:
    ; lea x12, forget_cut
    lea rax, forget_cut
    mov QWORD PTR [r15+96], rax
    ; ldr     x12, [x12]
    mov r10, QWORD PTR [r15+96]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+96], rax
    ; lea x10, console_task
    lea rax, console_task
    mov QWORD PTR [r15+80], rax
    ; mov     x11, x10
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r15+88], rax
    ; ldr     x13, [x10, #TU_LINK]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+104], rax
_tf_loop:
    ; cbz     x13, _tf_done
    mov rax, QWORD PTR [r15+104]
    cmp rax, 0
    je _tf_done
    ; cmp     x13, x10
    mov rax, QWORD PTR [r15+104]
    mov rcx, QWORD PTR [r15+80]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _tf_done
    cmp BYTE PTR [r15+249], 0
    jne _tf_done
    ; ldr     x14, [x13, #TU_LINK]
    mov r10, QWORD PTR [r15+104]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+112], rax
    ; cmp     x13, x12
    mov rax, QWORD PTR [r15+104]
    mov rcx, QWORD PTR [r15+96]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _tf_keep
    cmp BYTE PTR [r15+250], 0
    je _tf_keep
    ; str     x14, [x11, #TU_LINK]
    mov r10, QWORD PTR [r15+88]
    mov rax, QWORD PTR [r15+112]
    mov QWORD PTR [r10], rax
    ; lea x16, up_var
    lea rax, up_var
    mov QWORD PTR [r15+128], rax
    ; ldr     x17, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+136], rax
    ; cmp     x17, x13
    mov rax, QWORD PTR [r15+136]
    mov rcx, QWORD PTR [r15+104]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ne    _tf_next
    cmp BYTE PTR [r15+249], 0
    je _tf_next
    ; str     x10, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r10], rax
    ; mov     x27, x10
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r15+216], rax
_tf_next:
    ; mov     x13, x14
    mov rax, QWORD PTR [r15+112]
    mov QWORD PTR [r15+104], rax
    ; b       _tf_loop
    jmp _tf_loop
_tf_keep:
    ; ldr     x15, [x13, #TU_DP]
    mov r10, QWORD PTR [r15+104]
    add r10, 108h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+120], rax
    ; cbz     x15, _tf_keep_link
    mov rax, QWORD PTR [r15+120]
    cmp rax, 0
    je _tf_keep_link
    ; ldr     x16, [x13, #TU_DBASE]
    mov r10, QWORD PTR [r15+104]
    add r10, 100h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
    ; ldr     x17, [x13, #TU_DLIM]
    mov r10, QWORD PTR [r15+104]
    add r10, 110h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+136], rax
    ; cmp     x17, x12
    mov rax, QWORD PTR [r15+136]
    mov rcx, QWORD PTR [r15+96]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _tf_keep_link
    cmp BYTE PTR [r15+250], 0
    je _tf_keep_link
    cmp BYTE PTR [r15+249], 0
    jne _tf_keep_link
    ; cmp     x16, x12
    mov rax, QWORD PTR [r15+128]
    mov rcx, QWORD PTR [r15+96]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hs    _tf_slice_clear
    cmp BYTE PTR [r15+250], 0
    jne _tf_slice_clear
    ; cmp     x15, x12
    mov rax, QWORD PTR [r15+120]
    mov rcx, QWORD PTR [r15+96]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.ls    _tf_slice_lim
    cmp BYTE PTR [r15+250], 0
    je _tf_slice_lim
    cmp BYTE PTR [r15+249], 0
    jne _tf_slice_lim
    ; str     x12, [x13, #TU_DP]
    mov r10, QWORD PTR [r15+104]
    add r10, 108h
    mov rax, QWORD PTR [r15+96]
    mov QWORD PTR [r10], rax
_tf_slice_lim:
    ; str     x12, [x13, #TU_DLIM]
    mov r10, QWORD PTR [r15+104]
    add r10, 110h
    mov rax, QWORD PTR [r15+96]
    mov QWORD PTR [r10], rax
    ; b       _tf_keep_link
    jmp _tf_keep_link
_tf_slice_clear:
    ; str     xzr, [x13, #TU_DBASE]
    mov r10, QWORD PTR [r15+104]
    add r10, 100h
    mov QWORD PTR [r10], 0
    ; str     xzr, [x13, #TU_DP]
    mov r10, QWORD PTR [r15+104]
    add r10, 108h
    mov QWORD PTR [r10], 0
    ; str     xzr, [x13, #TU_DLIM]
    mov r10, QWORD PTR [r15+104]
    add r10, 110h
    mov QWORD PTR [r10], 0
_tf_keep_link:
    ; mov     x11, x13
    mov rax, QWORD PTR [r15+104]
    mov QWORD PTR [r15+88], rax
    ; mov     x13, x14
    mov rax, QWORD PTR [r15+112]
    mov QWORD PTR [r15+104], rax
    ; b       _tf_loop
    jmp _tf_loop
_tf_done:
    ; ret
    jmp QWORD PTR [r15+240]
_task_cold_init:
    ; lea x0, console_task
    lea rax, console_task
    mov QWORD PTR [r15+0], rax
    ; str     x0, [x0, #TU_LINK]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; mov     x1, #-1
    mov rax, -1
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_STATUS]
    mov r10, QWORD PTR [r15+0]
    add r10, 8
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; str     xzr, [x0, #TU_IP]
    mov r10, QWORD PTR [r15+0]
    add r10, 10h
    mov QWORD PTR [r10], 0
    ; str     xzr, [x0, #TU_TOS]
    mov r10, QWORD PTR [r15+0]
    add r10, 18h
    mov QWORD PTR [r10], 0
    ; str     x22, [x0, #TU_DSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 20h
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10], rax
    ; str     x23, [x0, #TU_RSP]
    mov r10, QWORD PTR [r15+0]
    add r10, 28h
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10], rax
    ; lea x1, data_stack
    lea rax, data_stack
    mov QWORD PTR [r15+8], rax
    ; add     x1, x1, #1, lsl #12
    mov rax, QWORD PTR [r15+8]
    add rax, 1000h
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_S0]
    mov r10, QWORD PTR [r15+0]
    add r10, 30h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, return_stack
    lea rax, return_stack
    mov QWORD PTR [r15+8], rax
    ; add     x1, x1, #1, lsl #12
    mov rax, QWORD PTR [r15+8]
    add rax, 1000h
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_R0]
    mov r10, QWORD PTR [r15+0]
    add r10, 38h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x1, #10
    mov rax, 0Ah
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_BASE]
    mov r10, QWORD PTR [r15+0]
    add r10, 40h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; str     xzr, [x0, #TU_STATE]
    mov r10, QWORD PTR [r15+0]
    add r10, 48h
    mov QWORD PTR [r10], 0
    ; str     xzr, [x0, #TU_RESUME]
    mov r10, QWORD PTR [r15+0]
    add r10, 50h
    mov QWORD PTR [r10], 0
    ; lea x1, XKEY_RETRY
    lea rax, XKEY_RETRY
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_RETRY_XT]
    mov r10, QWORD PTR [r15+0]
    add r10, 58h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; add     x1, x0, #TU_RETRY_XT
    mov rax, QWORD PTR [r15+0]
    add rax, 58h
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_RETRY_LIST]
    mov r10, QWORD PTR [r15+0]
    add r10, 60h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, up_var
    lea rax, up_var
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; lea x1, multi_var
    lea rax, multi_var
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, word_scratch
    lea rax, word_scratch
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_WORD_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0D8h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, pad_buffer
    lea rax, pad_buffer
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_PAD_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0E0h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, input_buffer
    lea rax, input_buffer
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_INPUT_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0E8h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, source_stack
    lea rax, source_stack
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_SSTK_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0F0h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, eval_resume_stack
    lea rax, eval_resume_stack
    mov QWORD PTR [r15+8], rax
    ; str     x1, [x0, #TU_EVALSTK_PTR]
    mov r10, QWORD PTR [r15+0]
    add r10, 0F8h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; str     xzr, [x0, #TU_DBASE]
    mov r10, QWORD PTR [r15+0]
    add r10, 100h
    mov QWORD PTR [r10], 0
    ; str     xzr, [x0, #TU_DP]
    mov r10, QWORD PTR [r15+0]
    add r10, 108h
    mov QWORD PTR [r10], 0
    ; str     xzr, [x0, #TU_DLIM]
    mov r10, QWORD PTR [r15+0]
    add r10, 110h
    mov QWORD PTR [r10], 0
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; lea x2, sem_graphics
    lea rax, sem_graphics
    mov QWORD PTR [r15+16], rax
    ; str     x1, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x2, sem_console
    lea rax, sem_console
    mov QWORD PTR [r15+16], rax
    ; str     x1, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x2, sem_dict
    lea rax, sem_dict
    mov QWORD PTR [r15+16], rax
    ; str     x1, [x2]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; lea x1, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+8], rax
    ; str     xzr, [x1]
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    ; lea x1, core_task
    lea rax, core_task
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #CORE_SLOTS
    mov rax, 0Ah
    mov QWORD PTR [r15+16], rax
Ltc_zap_task:
    ; str     xzr, [x1], #8
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR [r15+8]
    add rax, 8
    mov QWORD PTR [r15+8], rax
    ; subs    x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    sub rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+16], rax
    ; b.ne    Ltc_zap_task
    cmp BYTE PTR [r15+249], 0
    je Ltc_zap_task
    ; lea x1, core_pthread
    lea rax, core_pthread
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #CORE_SLOTS
    mov rax, 0Ah
    mov QWORD PTR [r15+16], rax
Ltc_zap_pthread:
    ; str     xzr, [x1], #8
    mov r10, QWORD PTR [r15+8]
    mov QWORD PTR [r10], 0
    mov rax, QWORD PTR [r15+8]
    add rax, 8
    mov QWORD PTR [r15+8], rax
    ; subs    x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    sub rax, 1
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    mov QWORD PTR [r15+16], rax
    ; b.ne    Ltc_zap_pthread
    cmp BYTE PTR [r15+249], 0
    je Ltc_zap_pthread
    ; mov     x27, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+216], rax
    ; ret
    jmp QWORD PTR [r15+240]
_core_leave:
    ; mov     x21, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+168], rax
    ; cbz     x27, _cl_noslot
    mov rax, QWORD PTR [r15+216]
    cmp rax, 0
    je _cl_noslot
    ; mov     x10, #0
    mov rax, 0
    mov QWORD PTR [r15+80], rax
    ; lea x9, core_task
    lea rax, core_task
    mov QWORD PTR [r15+72], rax
_cl_scan:
    ; ldr     x11, [x9, x10, lsl #3]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+80]
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+88], rax
    ; cmp     x11, x27
    mov rax, QWORD PTR [r15+88]
    mov rcx, QWORD PTR [r15+216]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _cl_hit
    cmp BYTE PTR [r15+249], 0
    jne _cl_hit
    ; add     x10, x10, #1
    mov rax, QWORD PTR [r15+80]
    add rax, 1
    mov QWORD PTR [r15+80], rax
    ; cmp     x10, #CORE_SLOTS
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _cl_scan
    cmp BYTE PTR [r15+250], 0
    je _cl_scan
_cl_noslot:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
_cl_hit:
    ; str     x19, [x27, #TU_IP]
    mov r10, QWORD PTR [r15+216]
    add r10, 10h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; str     x20, [x27, #TU_TOS]
    mov r10, QWORD PTR [r15+216]
    add r10, 18h
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; str     x22, [x27, #TU_DSP]
    mov r10, QWORD PTR [r15+216]
    add r10, 20h
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10], rax
    ; str     x23, [x27, #TU_RSP]
    mov r10, QWORD PTR [r15+216]
    add r10, 28h
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10], rax
    ; str     xzr, [x9, x10, lsl #3]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+80]
    shl rax, 3
    add r10, rax
    mov QWORD PTR [r10], 0
    ; lea x11, core_pthread
    lea rax, core_pthread
    mov QWORD PTR [r15+88], rax
    ; str     xzr, [x11, x10, lsl #3]
    mov r10, QWORD PTR [r15+88]
    mov rax, QWORD PTR [r15+80]
    shl rax, 3
    add r10, rax
    mov QWORD PTR [r10], 0
    ; lea x11, core_sp
    lea rax, core_sp
    mov QWORD PTR [r15+88], rax
    ; ldr     x11, [x11, x10, lsl #3]
    mov r10, QWORD PTR [r15+88]
    mov rax, QWORD PTR [r15+80]
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+88], rax
    ; mov     sp, x11
    mov rax, QWORD PTR [r15+88]
    mov rsp, rax
    ; mov     x0, x21
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r15+0], rax
    ; b       _ktr_epilogue
    jmp _ktr_epilogue
_core_is_worker:
    ; cbz     x27, _ciw_no
    mov rax, QWORD PTR [r15+216]
    cmp rax, 0
    je _ciw_no
    ; lea x1, core_task
    lea rax, core_task
    mov QWORD PTR [r15+8], rax
    ; mov     x2, #0
    mov rax, 0
    mov QWORD PTR [r15+16], rax
_ciw_loop:
    ; ldr     x3, [x1, x2, lsl #3]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+16]
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+24], rax
    ; cmp     x3, x27
    mov rax, QWORD PTR [r15+24]
    mov rcx, QWORD PTR [r15+216]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _ciw_yes
    cmp BYTE PTR [r15+249], 0
    jne _ciw_yes
    ; add     x2, x2, #1
    mov rax, QWORD PTR [r15+16]
    add rax, 1
    mov QWORD PTR [r15+16], rax
    ; cmp     x2, #CORE_SLOTS
    mov rax, QWORD PTR [r15+16]
    cmp rax, 0Ah
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.lo    _ciw_loop
    cmp BYTE PTR [r15+250], 0
    je _ciw_loop
_ciw_no:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_ciw_yes:
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; ret
    jmp QWORD PTR [r15+240]
_core_wait_self:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; stp     x9, x10, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+72]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+80]
    mov QWORD PTR [r10+8], rax
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cws_none
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cws_none
    ; lea x10, core_wait_hook
    lea rax, core_wait_hook
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cws_none
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cws_none
    ; mov     x0, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+0], rax
    ; blr     x10
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
    mov r11, QWORD PTR [r15+80]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; mov     x0, #1
    mov rax, 1
    mov QWORD PTR [r15+0], rax
    ; b       _cws_out
    jmp _cws_out
_cws_none:
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
_cws_out:
    ; ldp     x9, x10, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+72], rax
    mov QWORD PTR [r15+80], rcx
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
_core_wake:
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cw_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cw_fast
    ; lea x10, core_wake_hook
    lea rax, core_wake_hook
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cw_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cw_fast
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; blr     x10
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
    mov r11, QWORD PTR [r15+80]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
_cw_fast:
    ; ret
    jmp QWORD PTR [r15+240]
_core_join_call:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; lea x0, core_join_hook
    lea rax, core_join_hook
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    ; cbz     x0, _cjn_none
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _cjn_none
    ; blr     x0
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
    mov r11, QWORD PTR [r15+0]
    call r11
    mov QWORD PTR [r15+0], rax
    mov rsp, rbx
    pop rbx
_cjn_none:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; ret
    jmp QWORD PTR [r15+240]
_core_claim_any:
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cca_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cca_fast
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x9, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+72], rax
_cca_try:
    ; ldaxr   x1, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR arm_excl_addr, r10
    mov QWORD PTR arm_excl_val, rax
    mov QWORD PTR arm_excl, 1
    ; cbz     x1, _cca_busy
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _cca_busy
    ; stlxr   w2, xzr, [x9]
    mov r10, QWORD PTR [r15+72]
    cmp QWORD PTR arm_excl, 0
    je xxl_91
    cmp r10, QWORD PTR arm_excl_addr
    jne xxl_91
    mov rax, QWORD PTR arm_excl_val
    xor ecx, ecx
    lock cmpxchg QWORD PTR [r10], rcx
    mov QWORD PTR arm_excl, 0
    jne xxl_91
    xor eax, eax
    jmp xxl_92
    xxl_91:
    mov QWORD PTR arm_excl, 0
    mov eax, 1
    xxl_92:
    mov QWORD PTR [r15+16], rax
    ; cbnz    w2, _cca_try
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _cca_try
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
_cca_fast:
    ; ret
    jmp QWORD PTR [r15+240]
_cca_busy:
    ; clrex
    mov QWORD PTR arm_excl, 0
    ; bl      _core_wait_self
    lea rax, xret_93
    mov QWORD PTR [r15+240], rax
    jmp _core_wait_self
    xret_93:
    ; cbnz    x0, _cca_try
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _cca_try
    ; bl      _core_is_worker
    lea rax, xret_94
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_94:
    ; cbz     x0, _cca_abandon
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _cca_abandon
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; str     xzr, [x27, #TU_STATUS]
    mov r10, QWORD PTR [r15+216]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _core_leave
    jmp _core_leave
_cca_abandon:
    ; b       _error_abandon
    jmp _error_abandon
_core_claim_worker:
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _ccw_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _ccw_fast
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; stp     x9, x8, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+72]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+64]
    mov QWORD PTR [r10+8], rax
    ; mov     x9, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+72], rax
    ; bl      _core_is_worker
    lea rax, xret_95
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_95:
    ; cbz     x0, _ccw_pop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _ccw_pop
_ccw_try:
    ; ldaxr   x1, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    mov QWORD PTR arm_excl_addr, r10
    mov QWORD PTR arm_excl_val, rax
    mov QWORD PTR arm_excl, 1
    ; cbz     x1, _ccw_busy
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    je _ccw_busy
    ; stlxr   w2, xzr, [x9]
    mov r10, QWORD PTR [r15+72]
    cmp QWORD PTR arm_excl, 0
    je xxl_96
    cmp r10, QWORD PTR arm_excl_addr
    jne xxl_96
    mov rax, QWORD PTR arm_excl_val
    xor ecx, ecx
    lock cmpxchg QWORD PTR [r10], rcx
    mov QWORD PTR arm_excl, 0
    jne xxl_96
    xor eax, eax
    jmp xxl_97
    xxl_96:
    mov QWORD PTR arm_excl, 0
    mov eax, 1
    xxl_97:
    mov QWORD PTR [r15+16], rax
    ; cbnz    w2, _ccw_try
    mov eax, DWORD PTR [r15+16]
    cmp rax, 0
    jne _ccw_try
_ccw_pop:
    ; ldp     x9, x8, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+72], rax
    mov QWORD PTR [r15+64], rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
_ccw_fast:
    ; ret
    jmp QWORD PTR [r15+240]
_ccw_busy:
    ; clrex
    mov QWORD PTR arm_excl, 0
    ; bl      _core_wait_self
    lea rax, xret_98
    mov QWORD PTR [r15+240], rax
    jmp _core_wait_self
    xret_98:
    ; cbnz    x0, _ccw_try
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _ccw_try
    ; ldp     x9, x8, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+72], rax
    mov QWORD PTR [r15+64], rcx
    add rsp, 10h
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; str     xzr, [x27, #TU_STATUS]
    mov r10, QWORD PTR [r15+216]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _core_leave
    jmp _core_leave
_core_release_any:
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cra_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cra_fast
    ; mov     x9, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+72], rax
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; stlr    x1, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; b       _core_wake
    jmp _core_wake
_cra_fast:
    ; ret
    jmp QWORD PTR [r15+240]
_core_release_dict:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; lea x0, sem_dict
    lea rax, sem_dict
    mov QWORD PTR [r15+0], rax
    ; bl      _core_release_any
    lea rax, xret_99
    mov QWORD PTR [r15+240], rax
    jmp _core_release_any
    xret_99:
    ; ldr     x0, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
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
_core_release_worker:
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _crw_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _crw_fast
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x9, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+72], rax
    ; bl      _core_is_worker
    lea rax, xret_100
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_100:
    ; cbz     x0, _crw_pop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _crw_pop
    ; mov     x1, #1
    mov rax, 1
    mov QWORD PTR [r15+8], rax
    ; stlr    x1, [x9]
    mov r10, QWORD PTR [r15+72]
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; bl      _core_wake
    lea rax, xret_101
    mov QWORD PTR [r15+240], rax
    jmp _core_wake
    xret_101:
_crw_pop:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
_crw_fast:
    ; ret
    jmp QWORD PTR [r15+240]
_core_console_only:
    ; lea x10, cores_var
    lea rax, cores_var
    mov QWORD PTR [r15+80], rax
    ; ldr     x10, [x10]
    mov r10, QWORD PTR [r15+80]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+80], rax
    ; cbz     x10, _cco_fast
    mov rax, QWORD PTR [r15+80]
    cmp rax, 0
    je _cco_fast
    ; lea x10, console_task
    lea rax, console_task
    mov QWORD PTR [r15+80], rax
    ; cmp     x27, x10
    mov rax, QWORD PTR [r15+216]
    mov rcx, QWORD PTR [r15+80]
    cmp rax, rcx
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.eq    _cco_fast
    cmp BYTE PTR [r15+249], 0
    jne _cco_fast
    ; cbz     x27, _cco_fast
    mov rax, QWORD PTR [r15+216]
    cmp rax, 0
    je _cco_fast
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; bl      _core_is_worker
    lea rax, xret_102
    mov QWORD PTR [r15+240], rax
    jmp _core_is_worker
    xret_102:
    ; cbz     x0, _cco_pop
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _cco_pop
    ; lea x0, str_cores_word
    lea rax, str_cores_word
    mov QWORD PTR [r15+0], rax
    ; bl      _print_string_svc
    lea rax, xret_103
    mov QWORD PTR [r15+240], rax
    jmp _print_string_svc
    xret_103:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
    ; str     xzr, [x27, #TU_STATUS]
    mov r10, QWORD PTR [r15+216]
    add r10, 8
    mov QWORD PTR [r10], 0
    ; mov     x0, #0
    mov rax, 0
    mov QWORD PTR [r15+0], rax
    ; b       _core_leave
    jmp _core_leave
_cco_pop:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
_cco_fast:
    ; ret
    jmp QWORD PTR [r15+240]
BWSTR SEGMENT ALIGN(1) READ
nm_XHLD:
    ; DCB "HLD", 0
    DB "HLD", 0
hl_XHLD:
    ; DCB "HLD ( -- addr ) pictured numeric output pointer for this task", 0
    DB "HLD ( -- addr ) pictured numeric output pointer for this task", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XHLD:
    ; DCQ     nm_XHLD, hl_XHLD
    DQ OFFSET nm_XHLD, OFFSET hl_XHLD
    ; DCQ     0
    DQ 0
    ; DCQ     XHLD, XHLD_END
    DQ OFFSET XHLD, OFFSET XHLD_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XHLD
    DQ OFFSET row_XHLD
BOOTPTR ENDS
.CODE
XHLD:
    ; str     x20, [x22, #-8]!
    mov rax, QWORD PTR [r15+176]
    add rax, -8
    mov QWORD PTR [r15+176], rax
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10], rax
    ; mov     x0, x27
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r15+0], rax
    ; cbnz    x0, _xhld_up
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    jne _xhld_up
    ; lea x0, up_var
    lea rax, up_var
    mov QWORD PTR [r15+0], rax
    ; ldr     x0, [x0]
    mov r10, QWORD PTR [r15+0]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
_xhld_up:
    ; add     x0, x0, #TU_HLD
    mov rax, QWORD PTR [r15+0]
    add rax, 0C8h
    mov QWORD PTR [r15+0], rax
    ; mov     x20, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+160], rax
XHLD_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
kernel_task_enter:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; cbz     x0, _ktr_bad
    mov rax, QWORD PTR [r15+0]
    cmp rax, 0
    je _ktr_bad
    ; cmp     w1, #(CORE_SLOTS - 1)
    mov eax, DWORD PTR [r15+8]
    cmp eax, 9
    seto BYTE PTR [r15+251]
    sets BYTE PTR [r15+248]
    setz BYTE PTR [r15+249]
    setnc BYTE PTR [r15+250]
    ; b.hi    _ktr_bad
    cmp BYTE PTR [r15+250], 0
    je xsk_104
    cmp BYTE PTR [r15+249], 0
    je _ktr_bad
    xsk_104:
    ; uxtw    x1, w1
    mov eax, DWORD PTR [r15+8]
    mov QWORD PTR [r15+8], rax
    ; stp     x29, x30, [sp, #-112]!
    add rsp, -112
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x29, sp
    mov rax, rsp
    mov QWORD PTR [r15+232], rax
    ; stp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r10+8], rax
    ; stp     x21, x22, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r15+168]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+176]
    mov QWORD PTR [r10+8], rax
    ; stp     x23, x24, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r15+184]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+192]
    mov QWORD PTR [r10+8], rax
    ; stp     x25, x26, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r15+200]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+208]
    mov QWORD PTR [r10+8], rax
    ; stp     x27, x28, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r15+216]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+224]
    mov QWORD PTR [r10+8], rax
    ; str     x0, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; str     x1, [sp, #104]
    lea r10, [rsp]
    add r10, 68h
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r10], rax
    ; mov     x19, x0
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r15+152], rax
    ; mov     x20, x1
    mov rax, QWORD PTR [r15+8]
    mov QWORD PTR [r15+160], rax
    ; lea x2, core_sp
    lea rax, core_sp
    mov QWORD PTR [r15+16], rax
    ; mov     x3, sp
    mov rax, rsp
    mov QWORD PTR [r15+24], rax
    ; str     x3, [x2, x20, lsl #3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+160]
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r15+24]
    mov QWORD PTR [r10], rax
    ; lea x2, core_task
    lea rax, core_task
    mov QWORD PTR [r15+16], rax
    ; str     x19, [x2, x20, lsl #3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+160]
    shl rax, 3
    add r10, rax
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r10], rax
    ; mov     x27, x19
    mov rax, QWORD PTR [r15+152]
    mov QWORD PTR [r15+216], rax
    ; mov     x28, #0
    mov rax, 0
    mov QWORD PTR [r15+224], rax
    ; ldr     x19, [x27, #TU_IP]
    mov r10, QWORD PTR [r15+216]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+152], rax
    ; ldr     x20, [x27, #TU_TOS]
    mov r10, QWORD PTR [r15+216]
    add r10, 18h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    ; ldr     x22, [x27, #TU_DSP]
    mov r10, QWORD PTR [r15+216]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+176], rax
    ; ldr     x23, [x27, #TU_RSP]
    mov r10, QWORD PTR [r15+216]
    add r10, 28h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+184], rax
    ; lea x24, latest_var
    lea rax, latest_var
    mov QWORD PTR [r15+192], rax
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
ktr_fault_resume:
    ; ldr     x27, [sp, #96]
    lea r10, [rsp]
    add r10, 60h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+216], rax
    ; ldr     x1, [sp, #104]
    lea r10, [rsp]
    add r10, 68h
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; lea x2, core_task
    lea rax, core_task
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2, x1, lsl #3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+8]
    shl rax, 3
    add r10, rax
    mov QWORD PTR [r10], 0
    ; lea x2, core_pthread
    lea rax, core_pthread
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2, x1, lsl #3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+8]
    shl rax, 3
    add r10, rax
    mov QWORD PTR [r10], 0
    ; lea x2, core_sp
    lea rax, core_sp
    mov QWORD PTR [r15+16], rax
    ; str     xzr, [x2, x1, lsl #3]
    mov r10, QWORD PTR [r15+16]
    mov rax, QWORD PTR [r15+8]
    shl rax, 3
    add r10, rax
    mov QWORD PTR [r10], 0
    ; cbz     x27, _ktr_fault_go
    mov rax, QWORD PTR [r15+216]
    cmp rax, 0
    je _ktr_fault_go
    ; str     xzr, [x27, #TU_STATUS]
    mov r10, QWORD PTR [r15+216]
    add r10, 8
    mov QWORD PTR [r10], 0
_ktr_fault_go:
    ; mov     x0, #-1
    mov rax, -1
    mov QWORD PTR [r15+0], rax
    ; b       _ktr_epilogue
    jmp _ktr_epilogue
_ktr_epilogue:
    ; ldp     x19, x20, [sp, #16]
    lea r10, [rsp]
    add r10, 10h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+152], rax
    mov QWORD PTR [r15+160], rcx
    ; ldp     x21, x22, [sp, #32]
    lea r10, [rsp]
    add r10, 20h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+168], rax
    mov QWORD PTR [r15+176], rcx
    ; ldp     x23, x24, [sp, #48]
    lea r10, [rsp]
    add r10, 30h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+184], rax
    mov QWORD PTR [r15+192], rcx
    ; ldp     x25, x26, [sp, #64]
    lea r10, [rsp]
    add r10, 40h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+200], rax
    mov QWORD PTR [r15+208], rcx
    ; ldp     x27, x28, [sp, #80]
    lea r10, [rsp]
    add r10, 50h
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+216], rax
    mov QWORD PTR [r15+224], rcx
    ; ldp     x29, x30, [sp], #112
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 70h
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_ktr_bad:
    ; mov     x0, #-2
    mov rax, -2
    mov QWORD PTR [r15+0], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_error_abandon:
    ; lea x16, eval_frame_sp
    lea rax, eval_frame_sp
    mov QWORD PTR [r15+128], rax
    ; ldr     x16, [x16]
    mov r10, QWORD PTR [r15+128]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+128], rax
    ; mov     sp, x16
    mov rax, QWORD PTR [r15+128]
    mov rsp, rax
    ; b       _do_quit
    jmp _do_quit
_kernel_set_key_q:
kernel_set_key_q:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, key_q_hook
    lea rax, key_q_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_core_schedule:
kernel_set_core_schedule:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, core_schedule_hook
    lea rax, core_schedule_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_core_wait:
kernel_set_core_wait:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, core_wait_hook
    lea rax, core_wait_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_core_wake:
kernel_set_core_wake:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, core_wake_hook
    lea rax, core_wake_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
_kernel_set_core_join:
kernel_set_core_join:
    sub rsp, 48h
    mov QWORD PTR [rsp+28h], rcx
    mov QWORD PTR [rsp+30h], rdx
    mov QWORD PTR [rsp+38h], r8
    mov QWORD PTR [rsp+40h], r9
    call arm_load_base
    mov r15, rax
    mov rcx, QWORD PTR [rsp+28h]
    mov rdx, QWORD PTR [rsp+30h]
    mov r8, QWORD PTR [rsp+38h]
    mov r9, QWORD PTR [rsp+40h]
    add rsp, 40h
    mov QWORD PTR [r15+0], rcx
    mov QWORD PTR [r15+8], rdx
    mov QWORD PTR [r15+16], r8
    mov QWORD PTR [r15+24], r9
    ; lea x1, core_join_hook
    lea rax, core_join_hook
    mov QWORD PTR [r15+8], rax
    ; str     x0, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r15+0]
    mov QWORD PTR [r10], rax
    ; ret
    mov rax, QWORD PTR [r15+0]
    add rsp, 8
    ret
next_debug_gate:
    ; lea x16, next_debug
    lea rax, next_debug
    mov QWORD PTR [r15+128], rax
    ; br      x16
    mov rax, QWORD PTR [r15+128]
    jmp rax
.CONST
str_act_interp:
    ; DCB "ACTIVATE is only valid inside a colon definition", 10, 0
    DB "ACTIVATE is only valid inside a colon definition", 0Ah, 0
str_act_self:
    ; DCB "ACTIVATE: a task cannot activate itself", 10, 0
    DB "ACTIVATE: a task cannot activate itself", 0Ah, 0
str_allot_over:
    ; DCB "ALLOT: dictionary full (need more USER-DICT space)", 10, 0
    DB "ALLOT: dictionary full (need more USER-DICT space)", 0Ah, 0
str_allot_under:
    ; DCB "ALLOT: below dictionary start", 10, 0
    DB "ALLOT: below dictionary start", 0Ah, 0
str_cores_console:
    ; DCB "? CORES only from the console task", 10, 0
    DB "? CORES only from the console task", 0Ah, 0
str_cores_word:
    ; DCB "? CORES: console only", 10, 0
    DB "? CORES: console only", 0Ah, 0
str_dict_full:
    ; DCB "dictionary full (code/data space exhausted)", 10, 0
    DB "dictionary full (code/data space exhausted)", 0Ah, 0
str_mbox_get_stuck:
    ; DCB "? MBOX>: no other task can send", 10, 0
    DB "? MBOX>: no other task can send", 0Ah, 0
str_mbox_put_stuck:
    ; DCB "? >MBOX: no other task can receive", 10, 0
    DB "? >MBOX: no other task can receive", 0Ah, 0
str_qget_stuck:
    ; DCB "? Q>: no other task can send", 10, 0
    DB "? Q>: no other task can send", 0Ah, 0
str_qput_stuck:
    ; DCB "? >Q: no other task can receive", 10, 0
    DB "? >Q: no other task can receive", 0Ah, 0
str_queue_n:
    ; DCB "? QUEUE: need at least 2 slots", 10, 0
    DB "? QUEUE: need at least 2 slots", 0Ah, 0
str_sleep_only:
    ; DCB "SLEEP: the console is the only awake task", 10, 0
    DB "SLEEP: the console is the only awake task", 0Ah, 0
str_slice_bad:
    ; DCB "? SLICE: sleeping task and a positive size", 10, 0
    DB "? SLICE: sleeping task and a positive size", 0Ah, 0
str_slice_console:
    ; DCB "? SLICE only from the console task", 10, 0
    DB "? SLICE only from the console task", 0Ah, 0
str_slice_none:
    ; DCB "? SLICE: task has no dictionary", 10, 0
    DB "? SLICE: task has no dictionary", 0Ah, 0
str_stop_console:
    ; DCB "STOP: the console task stays awake", 10, 0
    DB "STOP: the console task stays awake", 0Ah, 0
str_wait_stuck:
    ; DCB "? WAIT: no other task can SIGNAL", 10, 0
    DB "? WAIT: no other task can SIGNAL", 0Ah, 0
BWSTR SEGMENT ALIGN(1) READ
nm_XSOURCE_STORE:
    ; DCB "(SOURCE!)", 0
    DB "(SOURCE!)", 0
hl_XSOURCE_STORE:
    ; DCB "(SOURCE!) ( c-addr u -- ) set this task's SOURCE and zero >IN", 0
    DB "(SOURCE!) ( c-addr u -- ) set this task's SOURCE and zero >IN", 0
BWSTR ENDS
BOOTWORD SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
row_XSOURCE_STORE:
    ; DCQ     nm_XSOURCE_STORE, hl_XSOURCE_STORE
    DQ OFFSET nm_XSOURCE_STORE, OFFSET hl_XSOURCE_STORE
    ; DCQ     0
    DQ 0
    ; DCQ     XSOURCE_STORE, XSOURCE_STORE_END
    DQ OFFSET XSOURCE_STORE, OFFSET XSOURCE_STORE_END
BOOTWORD ENDS
BOOTPTR SEGMENT ALIGN(8) READ
    ; ALIGN 8
ALIGN 8
    ; DCQ     row_XSOURCE_STORE
    DQ OFFSET row_XSOURCE_STORE
BOOTPTR ENDS
.CODE
XSOURCE_STORE:
    ; stp     x29, x30, [sp, #-16]!
    add rsp, -16
    lea r10, [rsp]
    mov rax, QWORD PTR [r15+232]
    mov QWORD PTR [r10+0], rax
    mov rax, QWORD PTR [r15+240]
    mov QWORD PTR [r10+8], rax
    ; mov     x1, x20
    mov rax, QWORD PTR [r15+160]
    mov QWORD PTR [r15+8], rax
    ; ldr     x0, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+0], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; ldr     x20, [x22], #8
    mov r10, QWORD PTR [r15+176]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+160], rax
    mov rax, QWORD PTR [r15+176]
    add rax, 8
    mov QWORD PTR [r15+176], rax
    ; bl      _set_source
    lea rax, xret_105
    mov QWORD PTR [r15+240], rax
    jmp _set_source
    xret_105:
    ; ldp     x29, x30, [sp], #16
    lea r10, [rsp]
    mov rax, QWORD PTR [r10]
    mov rcx, QWORD PTR [r10+8]
    mov QWORD PTR [r15+232], rax
    mov QWORD PTR [r15+240], rcx
    add rsp, 10h
XSOURCE_STORE_END:
    ; cbnz    x28, next_debug_gate
    mov rax, QWORD PTR [r15+224]
    cmp rax, 0
    jne next_debug_gate
    ; lea x1, debug_break_asap
    lea rax, debug_break_asap
    mov QWORD PTR [r15+8], rax
    ; ldr     x1, [x1]
    mov r10, QWORD PTR [r15+8]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; cbnz    x1, next_debug_gate
    mov rax, QWORD PTR [r15+8]
    cmp rax, 0
    jne next_debug_gate
    ; ldr     x21, [x19], #8
    mov r10, QWORD PTR [r15+152]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+168], rax
    mov rax, QWORD PTR [r15+152]
    add rax, 8
    mov QWORD PTR [r15+152], rax
    ; ldr     x1, [x21]
    mov r10, QWORD PTR [r15+168]
    mov rax, QWORD PTR [r10]
    mov QWORD PTR [r15+8], rax
    ; br      x1
    mov rax, QWORD PTR [r15+8]
    jmp rax
.DATA
console_task:
    ; SPACE TU_BYTES
    DB 280 DUP(0)
console_hw_sp:
    ; DCQ 0
    DQ 0
up_var:
    ; DCQ 0
    DQ 0
multi_var:
    ; DCQ 0
    DQ 0
cores_var:
    ; DCQ 0
    DQ 0
console_pthread:
    ; DCQ 0
    DQ 0
stop_retry_xt:
    ; DCQ XSTOP
    DQ OFFSET XSTOP
park_retry_xt:
    ; DCQ XPARK
    DQ OFFSET XPARK
task_stop_thread:
    ; DCQ stop_retry_xt
    DQ OFFSET stop_retry_xt
park_thread:
    ; DCQ park_retry_xt
    DQ OFFSET park_retry_xt
wait_retry_xt:
    ; DCQ XWAIT_RETRY
    DQ OFFSET XWAIT_RETRY
wait_thread:
    ; DCQ wait_retry_xt
    DQ OFFSET wait_retry_xt
sem_graphics:
    ; DCQ 1
    DQ 1
sem_console:
    ; DCQ 1
    DQ 1
sem_dict:
    ; DCQ 1
    DQ 1
mbox_put_retry_xt:
    ; DCQ XMBOX_PUT_RETRY
    DQ OFFSET XMBOX_PUT_RETRY
mbox_put_thread:
    ; DCQ mbox_put_retry_xt
    DQ OFFSET mbox_put_retry_xt
mbox_get_retry_xt:
    ; DCQ XMBOX_GET_RETRY
    DQ OFFSET XMBOX_GET_RETRY
mbox_get_thread:
    ; DCQ mbox_get_retry_xt
    DQ OFFSET mbox_get_retry_xt
qput_retry_xt:
    ; DCQ XQPUT_RETRY
    DQ OFFSET XQPUT_RETRY
qput_thread:
    ; DCQ qput_retry_xt
    DQ OFFSET qput_retry_xt
qget_retry_xt:
    ; DCQ XQGET_RETRY
    DQ OFFSET XQGET_RETRY
qget_thread:
    ; DCQ qget_retry_xt
    DQ OFFSET qget_retry_xt
    ; ALIGN 8
ALIGN 8
core_sp:
    ; SPACE 80
    DB 80 DUP(0)
core_task:
    ; SPACE 80
    DB 80 DUP(0)
core_pthread:
    ; SPACE 80
    DB 80 DUP(0)
key_q_hook:
    ; DCQ 0
    DQ 0
core_schedule_hook:
    ; DCQ 0
    DQ 0
core_wait_hook:
    ; DCQ 0
    DQ 0
core_wake_hook:
    ; DCQ 0
    DQ 0
core_join_hook:
    ; DCQ 0
    DQ 0
    ; ALIGN 8
ALIGN 8
input_buffer:
    ; SPACE 1024
    DB 1024 DUP(0)
eval_frame_sp:
    ; DCQ 0
    DQ 0
END
