; Cooperative tasks, KEY yield, mailboxes, queues, and CORES helpers.
; Ported from the Mac kernel. Darwin nanosleep is host_pause.
; x27 is the user area of the task running on this thread.

        INCLUDE Forth/kernel/arm64/vm.inc

        EXTERN  next_debug
        EXTERN  debug_break_asap
        INCLUDE Forth/kernel/arm64/boot_words.inc

TU_LINK            EQU 0
TU_STATUS          EQU 8
TU_IP              EQU 16
TU_TOS             EQU 24
TU_DSP             EQU 32
TU_RSP             EQU 40
TU_S0              EQU 48
TU_R0              EQU 56
TU_BASE            EQU 64
TU_STATE           EQU 72
TU_RESUME          EQU 80
TU_RETRY_XT        EQU 88
TU_RETRY_LIST      EQU 96
TU_DBASE           EQU 256
TU_DP              EQU 264
TU_DLIM            EQU 272
TU_BYTES           EQU 280
HEADER_ROOM        EQU 512
TASK_STACK_BYTES   EQU 4096
TASK_WORD_BYTES    EQU 512
TASK_PAD_BYTES     EQU 1024
TASK_INPUT_BYTES   EQU 1024
TASK_SRCSTK_BYTES  EQU 640
TASK_EVALSTK_BYTES EQU 64
CORE_SLOTS         EQU 10
RETURN_STACK_SIZE  EQU 4096
MB_VALUE           EQU 0
MB_FULL            EQU 8
MB_EMPTY           EQU 16
MB_BYTES           EQU 24
Q_CAP              EQU 0
Q_HEAD             EQU 8
Q_TAIL             EQU 16
Q_SLOTS            EQU 24
TASK_SCRATCH_BYTES EQU TASK_WORD_BYTES + TASK_PAD_BYTES + TASK_INPUT_BYTES + TASK_SRCSTK_BYTES + TASK_EVALSTK_BYTES
TASK_ALLOT      EQU TU_BYTES + TASK_STACK_BYTES + TASK_STACK_BYTES + TASK_SCRATCH_BYTES

        EXTERN  host_pause
        EXTERN  _set_source
        EXTERN  _print_string_svc
        EXTERN  _getchar
        EXTERN  _do_quit
        EXTERN  here_ptr
        EXTERN  user_dict_area
        EXTERN  user_dict_size_cell
        EXTERN  base_var
        EXTERN  state_var
        EXTERN  word_scratch
        EXTERN  pad_buffer
        EXTERN  source_stack
        EXTERN  eval_resume_stack
        EXTERN  data_stack
        EXTERN  return_stack
        EXTERN  forget_cut
        EXTERN  restart_cell
        EXTERN  latest_var
        EXTERN  pause_hook
        EXTERN  debug_armed
        EXTERN  debug_busy

        EXPORT  _task_yield
        EXPORT  _dict_allot
        EXPORT  _here_reserve
        EXPORT  _here_reserve_exact
        EXPORT  _task_dp_bounds
        EXPORT  _task_require_dict
        EXPORT  _task_cold_init
        EXPORT  _task_forget_cut
        EXPORT  _task_park_fail
        EXPORT  _task_stop_or_abandon
        EXPORT  _task_is_console
        EXPORT  _task_other_awake
        EXPORT  _task_can_switch
        EXPORT  _core_console_only
        EXPORT  _core_is_worker
        EXPORT  _core_leave
        EXPORT  _core_wake
        EXPORT  _core_join_call
        EXPORT  _core_wait_self
        EXPORT  _core_claim_any
        EXPORT  _core_claim_worker
        EXPORT  _core_release_any
        EXPORT  _core_release_dict
        EXPORT  _core_release_worker
        EXPORT  _error_abandon
        EXPORT  kernel_task_enter
        EXPORT  ktr_fault_resume
        EXPORT  kernel_set_key_q
        EXPORT  kernel_set_core_schedule
        EXPORT  kernel_set_core_wait
        EXPORT  kernel_set_core_wake
        EXPORT  kernel_set_core_join
        EXPORT  console_task
        EXPORT  up_var
        EXPORT  multi_var
        EXPORT  cores_var
        EXPORT  key_q_hook
        EXPORT  eval_frame_sp
        EXPORT  input_buffer
        EXPORT  core_sp
        EXPORT  core_task
        EXPORT  core_pthread
        EXPORT  sem_graphics
        EXPORT  sem_console
        EXPORT  sem_dict
        EXPORT  park_thread
        EXPORT  wait_thread
        EXPORT  task_stop_thread
        EXPORT  mbox_put_thread
        EXPORT  mbox_get_thread
        EXPORT  qput_thread
        EXPORT  qget_thread
        EXPORT  console_pthread
        EXPORT  core_schedule_hook
        EXPORT  core_wait_hook
        EXPORT  core_wake_hook
        EXPORT  core_join_hook
        EXPORT  XSTOP
        EXPORT  str_allot_over
        EXPORT  str_allot_under
        EXPORT  str_dict_full

        AREA |.text|, CODE, READONLY, ALIGN=4

        AREA |.bwstr|, DATA, READONLY
nm_XKEY DCB "KEY", 0
hl_XKEY DCB "KEY ( -- c ) wait for and return next character (skips K-* function-key events)", 0
        BOOT_ROW nm_XKEY, hl_XKEY, 0, XKEY, XKEY_END, row_XKEY
XKEY
xkey_poll
        ; MULTI and another awake task: poll. A waiting KEY yields instead of
        ; blocking the only Forth queue. No KEY? hook → keep the blocking read.
        bl      _task_can_switch
        cbz     x0, xkey_block
        adrp    x1, key_q_hook
        add     x1, x1, key_q_hook
        ldr     x1, [x1]
        cbz     x1, xkey_block ; no KEY? hook: keep the blocking read
        bl      _key_poll_ready
        cbnz    x0, xkey_block
        adrp    x5, up_var
        add     x5, x5, up_var
        ldr     x5, [x5]
        str     x19, [x5, #TU_RESUME]
        add     x19, x5, #TU_RETRY_LIST
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.eq    xkey_stay
        NEXT
xkey_stay
        ldr     x19, [x5, #TU_RESUME]
xkey_block
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        bl      _getchar
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ; Break Now while blocked in KEY: do not push a character (that would
        ; look like a key to the caller). Back up IP onto KEY and re-enter
        ; next_debug, which pauses on this token. Step runs KEY again.
        mov     x1, #-2
        cmp     x0, x1
        b.ne    xkey_char
        sub     x19, x19, #8
        b       next_debug_gate
xkey_char
        ; Function-key event (2<<24): skip for KEY, leave for EKEY consumers
        mov     x1, x0
        lsr     x2, x1, #24
        and     x2, x2, #0xFF
        cmp     x2, #2
        b.eq    xkey_poll
        ; Character event (1<<24): low 21 bits are the code point
        cmp     x2, #1
        b.ne    xkey_push
        mov     x3, #0x1FFFFF
        and     x0, x1, x3
xkey_push
        DPUSH
XKEY_END
        NEXT

; KEY? ( -- flag )  true if a character is available (does not read it)

        AREA |.bwstr|, DATA, READONLY
nm_XKEYQ DCB "KEY?", 0
hl_XKEYQ DCB "KEY? ( -- flag ) true if a key is available (does not consume)", 0
        BOOT_ROW nm_XKEYQ, hl_XKEYQ, 0, XKEYQ, XKEYQ_END, row_XKEYQ
XKEYQ
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        adrp    x1, key_q_hook
        add     x1, x1, key_q_hook
        ldr     x1, [x1]
        cbz     x1, xkeyq_none
        blr     x1 ; int (*)(void) → non-zero if ready
        b       xkeyq_flag
xkeyq_none
        mov     x0, #0
xkeyq_flag
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        str     x20, [x22, #-8]!
        cmp     x0, #0
        csinv   x20, xzr, xzr, eq ; Forth true = -1
XKEYQ_END
        NEXT
        AREA |.bwstr|, DATA, READONLY
nm_XPAUSE DCB "(PAUSE-HOOK)", 0
hl_XPAUSE DCB "(PAUSE-HOOK) ( -- ) show pending console output, then wait 1 ms", 0
        BOOT_ROW nm_XPAUSE, hl_XPAUSE, 0, XPAUSE, XPAUSE_END, row_XPAUSE
XPAUSE
        stp     x19, x20, [sp, #-16]!
        stp     x21, x22, [sp, #-16]!
        stp     x23, x24, [sp, #-16]!
        adrp    x1, pause_hook
        add     x1, x1, pause_hook
        ldr     x1, [x1]
        cbz     x1, xpause_host
        blr     x1
        b       xpause_restore
xpause_host
        bl      host_pause ; 1 ms
xpause_restore
        ldp     x23, x24, [sp], #16
        ldp     x21, x22, [sp], #16
        ldp     x19, x20, [sp], #16
        ; A worker PAUSE returns so the host can run a sibling on this queue.
        bl      _core_is_worker
        cbz     x0, XPAUSE_END
        mov     x0, #1
        b       _core_leave
XPAUSE_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XTASK_PAUSE DCB "PAUSE", 0
hl_XTASK_PAUSE DCB "PAUSE ( -- ) yield when MULTI, then show pending output and wait 1 ms", 0
        BOOT_ROW nm_XTASK_PAUSE, hl_XTASK_PAUSE, 0, XTASK_PAUSE, XTASK_PAUSE_END, row_XTASK_PAUSE
XTASK_PAUSE
        bl      _task_can_switch
        cbz     x0, XPAUSE
        bl      _task_yield
        b       XPAUSE
XTASK_PAUSE_END

; ============================================================================
; Cooperative tasks (phase 1). One VM, one queue. PAUSE yields when MULTI.
; User area is TU_BYTES, then a 512-cell data stack, then a 512-cell return
; stack, then scratch. TU_DBASE, TU_DP, and TU_DLIM stay 0 until SLICE.
; Offsets are the TU_* equates near RETURN_STACK_SIZE.
; The console task lives in BSS and keeps the original stacks. Its three
; slice cells stay 0, so console compilation keeps using here_ptr.
; ============================================================================

; x0 = 1 if some task other than the current one is awake.
_task_other_awake
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cbz     x0, _toa_no
        mov     x1, x0
        ldr     x2, [x0, #TU_LINK]
_toa_loop
        cbz     x2, _toa_no
        cmp     x2, x1
        b.eq    _toa_no
        ldr     x3, [x2, #TU_STATUS]
        cbnz    x3, _toa_yes
        ldr     x2, [x2, #TU_LINK]
        b       _toa_loop
_toa_yes
        mov     x0, #1
        ret
_toa_no
        mov     x0, #0
        ret

; x0 = 1 when PAUSE / KEY should switch. Debugger and Break Now hold the VM.
_task_can_switch
        stp     x29, x30, [sp, #-16]!
        ; CORES parks on the host semaphore. Do not inline-switch a worker
        ; onto the console thread.
        adrp    x0, cores_var
        add     x0, x0, cores_var
        ldr     x0, [x0]
        cbnz    x0, _tcs_no
        adrp    x0, multi_var
        add     x0, x0, multi_var
        ldr     x0, [x0]
        cbz     x0, _tcs_no
        adrp    x0, debug_armed
        add     x0, x0, debug_armed
        ldr     x0, [x0]
        cbnz    x0, _tcs_no
        adrp    x0, debug_busy
        add     x0, x0, debug_busy
        ldr     x0, [x0]
        cbnz    x0, _tcs_no
        adrp    x0, debug_break_asap
        add     x0, x0, debug_break_asap
        ldr     x0, [x0]
        cbnz    x0, _tcs_no
        bl      _task_other_awake
        ldp     x29, x30, [sp], #16
        ret
_tcs_no
        mov     x0, #0
        ldp     x29, x30, [sp], #16
        ret

; x0 nonzero if key_q_hook says a key is waiting. 0 if the hook is absent.
_key_poll_ready
        stp     x29, x30, [sp, #-16]!
        adrp    x1, key_q_hook
        add     x1, x1, key_q_hook
        ldr     x1, [x1]
        cbz     x1, _kpr_no
        blr     x1
        ldp     x29, x30, [sp], #16
        ret
_kpr_no
        mov     x0, #0
        ldp     x29, x30, [sp], #16
        ret

; x0 = 1 if the running task is the console, else 0. Preserves x19–x24.
_task_is_console
        mov     x0, x27
        cbnz    x0, _tic_cmp
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
_tic_cmp
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x0, x1
        csinc   x0, xzr, xzr, ne
        ret

; Save the current task and load the next awake task.
; x19 is the IP to resume. On return, x19–x23 and BASE/STATE match the
; task that should run. No switch reloads the saved copy (same values).
; Temps are x9–x13 so callers may hold a user-area pointer in x5 and a
; saved IP in x6 across the call.
_task_yield
        stp     x29, x30, [sp, #-16]!
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cbz     x0, _ty_done
        str     x19, [x0, #TU_IP]
        str     x20, [x0, #TU_TOS]
        str     x22, [x0, #TU_DSP]
        str     x23, [x0, #TU_RSP]
        adrp    x9, base_var
        add     x9, x9, base_var
        ldr     x10, [x9]
        str     x10, [x0, #TU_BASE]
        adrp    x9, state_var
        add     x9, x9, state_var
        ldr     x10, [x9]
        str     x10, [x0, #TU_STATE]
        mov     x11, x0
        ldr     x12, [x0, #TU_LINK]
_ty_loop
        cbz     x12, _ty_stay
        cmp     x12, x11
        b.eq    _ty_stay
        ldr     x13, [x12, #TU_STATUS]
        cbnz    x13, _ty_take
        ldr     x12, [x12, #TU_LINK]
        b       _ty_loop
_ty_take
        ldr     x19, [x12, #TU_IP]
        ldr     x20, [x12, #TU_TOS]
        ldr     x22, [x12, #TU_DSP]
        ldr     x23, [x12, #TU_RSP]
        ldr     x10, [x12, #TU_BASE]
        adrp    x9, base_var
        add     x9, x9, base_var
        str     x10, [x9]
        ldr     x10, [x12, #TU_STATE]
        adrp    x9, state_var
        add     x9, x9, state_var
        str     x10, [x9]
        adrp    x9, up_var
        add     x9, x9, up_var
        str     x12, [x9]
        mov     x27, x12
        ; A task that stops inside ALLOT leaves C frames on this stack.
        ; The console resume point was saved when it yielded. Jumping back
        ; there drops those frames so kernel_eval's epilogue still matches.
        adrp    x9, console_task
        add     x9, x9, console_task
        cmp     x12, x9
        b.ne    _ty_leaving_console
        adrp    x10, console_hw_sp
        add     x10, x10, console_hw_sp
        ldr     x10, [x10]
        cbz     x10, _ty_done
        mov     sp, x10
        NEXT
_ty_leaving_console
        cmp     x11, x9
        b.ne    _ty_done
        adrp    x10, console_hw_sp
        add     x10, x10, console_hw_sp
        add     x13, sp, #16
        str     x13, [x10]
        b       _ty_done
_ty_stay
        ldr     x19, [x11, #TU_IP]
        ldr     x20, [x11, #TU_TOS]
        ldr     x22, [x11, #TU_DSP]
        ldr     x23, [x11, #TU_RSP]
_ty_done
        ldp     x29, x30, [sp], #16
        ret

; KEY resumes here after a yield. x19 was left just past TU_RETRY_LIST.
XKEY_RETRY
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        ldr     x19, [x0, #TU_RESUME]
        b       XKEY

; Finished-task park. Entered from the stop sentinel. Sleeps until another
; task is awake, then yields. A later WAKE comes back here.
XPARK
        adrp    x5, up_var
        add     x5, x5, up_var
        ldr     x5, [x5]
        str     xzr, [x5, #TU_STATUS]
        adrp    x19, park_thread
        add     x19, x19, park_thread
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.eq    _xpark_alone
        NEXT
_xpark_alone
        mov     x1, #-1
        str     x1, [x5, #TU_STATUS]
        bl      host_pause ; 1 ms
        b       XPARK

        AREA |.bwstr|, DATA, READONLY
nm_XYIELD DCB "(YIELD)", 0
hl_XYIELD DCB "(YIELD) ( -- ) switch to the next awake task when MULTI", 0
        BOOT_ROW nm_XYIELD, hl_XYIELD, 0, XYIELD, XYIELD_END, row_XYIELD
XYIELD
        bl      _task_can_switch
        cbz     x0, XYIELD_END
        bl      _task_yield
XYIELD_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XMULTI DCB "MULTI", 0
hl_XMULTI DCB "MULTI ( -- ) arm cooperative task switching", 0
        BOOT_ROW nm_XMULTI, hl_XMULTI, 0, XMULTI, XMULTI_END, row_XMULTI
XMULTI
        adrp    x0, multi_var
        add     x0, x0, multi_var
        mov     x1, #-1
        str     x1, [x0]
XMULTI_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XSINGLE DCB "SINGLE", 0
hl_XSINGLE DCB "SINGLE ( -- ) cooperative PAUSE does not switch", 0
        BOOT_ROW nm_XSINGLE, hl_XSINGLE, 0, XSINGLE, XSINGLE_END, row_XSINGLE
XSINGLE
        adrp    x0, multi_var
        add     x0, x0, multi_var
        str     xzr, [x0]
XSINGLE_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XCORES DCB "CORES", 0
hl_XCORES DCB "CORES ( -- ) run tasks on up to ten worker queues", 0
        BOOT_ROW nm_XCORES, hl_XCORES, 0, XCORES, XCORES_END, row_XCORES
XCORES
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x27, x1
        b.eq    _xcores_ok
        adrp    x0, str_cores_console
        add     x0, x0, str_cores_console
        bl      _print_string_svc
        NEXT
_xcores_ok
        adrp    x0, cores_var
        add     x0, x0, cores_var
        mov     x1, #-1
        str     x1, [x0]
XCORES_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XCOOP DCB "COOP", 0
hl_XCOOP DCB "COOP ( -- ) wait for worker tasks, then use the cooperative scheduler", 0
        BOOT_ROW nm_XCOOP, hl_XCOOP, 0, XCOOP, XCOOP_END, row_XCOOP
XCOOP
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x27, x1
        b.eq    _xcoop_ok
        adrp    x0, str_cores_console
        add     x0, x0, str_cores_console
        bl      _print_string_svc
        NEXT
_xcoop_ok
        bl      _core_join_call
        adrp    x0, cores_var
        add     x0, x0, cores_var
        str     xzr, [x0]
XCOOP_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XCORES_JOIN DCB "CORES-JOIN", 0
hl_XCORES_JOIN DCB "CORES-JOIN ( -- ) wait until worker tasks have stopped", 0
        BOOT_ROW nm_XCORES_JOIN, hl_XCORES_JOIN, 0, XCORES_JOIN, XCORES_JOIN_END, row_XCORES_JOIN
XCORES_JOIN
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x27, x1
        b.eq    _xjoin_ok
        adrp    x0, str_cores_console
        add     x0, x0, str_cores_console
        bl      _print_string_svc
        NEXT
_xjoin_ok
        bl      _core_join_call
XCORES_JOIN_END
        NEXT

; Binary semaphore cell: 1 is free, 0 is taken. CLAIM stores 0 only while
; this core still holds the exclusive reservation. A 0 is left unchanged.
; RELEASE stores 1 with a release store. WAIT parks by yielding. SIGNAL
; releases, then yields so a parked waiter can claim.

        AREA |.bwstr|, DATA, READONLY
nm_XCLAIM DCB "CLAIM", 0
hl_XCLAIM DCB "CLAIM ( addr -- flag ) take a free semaphore; true if this task stored 0", 0
        BOOT_ROW nm_XCLAIM, hl_XCLAIM, 0, XCLAIM, XCLAIM_END, row_XCLAIM
XCLAIM
        mov     x0, x20
_claim_try
        ldaxr   x1, [x0]
        cbz     x1, _claim_busy
        stlxr   w2, xzr, [x0]
        cbnz    w2, _claim_try
        mov     x20, #-1
        b       XCLAIM_END
_claim_busy
        clrex
        mov     x20, #0
XCLAIM_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XRELEASE DCB "RELEASE", 0
hl_XRELEASE DCB "RELEASE ( addr -- ) store 1 into a semaphore with a release store", 0
        BOOT_ROW nm_XRELEASE, hl_XRELEASE, 0, XRELEASE, XRELEASE_END, row_XRELEASE
XRELEASE
        mov     x1, #1
        stlr    x1, [x20]
        ldr     x20, [x22], #8
        bl      _core_wake
XRELEASE_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XWAIT DCB "WAIT", 0
hl_XWAIT DCB "WAIT ( addr -- ) CLAIM until it succeeds, yielding while the semaphore is taken", 0
        BOOT_ROW nm_XWAIT, hl_XWAIT, 0, XWAIT, XWAIT_END, row_XWAIT
; Parked WAIT resumes here. NEXT has already stepped past wait_thread,
; so reload the colon continuation saved in TU_RESUME and claim again.
XWAIT_RETRY
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        ldr     x19, [x0, #TU_RESUME]
        b       XWAIT
XWAIT
        mov     x0, x20
_wait_try
        ldaxr   x1, [x0]
        cbz     x1, _wait_busy
        stlxr   w2, xzr, [x0]
        cbnz    w2, _wait_try
        ldr     x20, [x22], #8
        b       XWAIT_END
_wait_busy
        clrex
        bl      _core_wait_self
        cbz     x0, _wait_coop
        b       XWAIT
_wait_coop
        bl      _task_can_switch
        cbz     x0, _wait_stuck
        adrp    x5, up_var
        add     x5, x5, up_var
        ldr     x5, [x5]
        str     x19, [x5, #TU_RESUME]
        adrp    x19, wait_thread
        add     x19, x19, wait_thread
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.ne    XWAIT_END
        ldr     x19, [x5, #TU_RESUME]
_wait_stuck
        ldr     x20, [x22], #8
        adrp    x0, str_wait_stuck
        add     x0, x0, str_wait_stuck
        bl      _print_string_svc
XWAIT_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XSIGNAL DCB "SIGNAL", 0
hl_XSIGNAL DCB "SIGNAL ( addr -- ) RELEASE, then yield so a waiting task can CLAIM", 0
        BOOT_ROW nm_XSIGNAL, hl_XSIGNAL, 0, XSIGNAL, XSIGNAL_END, row_XSIGNAL
XSIGNAL
        mov     x1, #1
        stlr    x1, [x20]
        ldr     x20, [x22], #8
        bl      _core_wake
        bl      _task_can_switch
        cbz     x0, XSIGNAL_END
        bl      _task_yield
XSIGNAL_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XGRAPHICS_SEM DCB "GRAPHICS-SEM", 0
hl_XGRAPHICS_SEM DCB "GRAPHICS-SEM ( -- addr ) semaphore for the graphics map (1 = free)", 0
        BOOT_ROW nm_XGRAPHICS_SEM, hl_XGRAPHICS_SEM, 0, XGRAPHICS_SEM, 0, row_XGRAPHICS_SEM
XGRAPHICS_SEM
        str     x20, [x22, #-8]!
        adrp    x20, sem_graphics
        add     x20, x20, sem_graphics
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XCONSOLE_SEM DCB "CONSOLE-SEM", 0
hl_XCONSOLE_SEM DCB "CONSOLE-SEM ( -- addr ) semaphore for the console emit buffer (1 = free)", 0
        BOOT_ROW nm_XCONSOLE_SEM, hl_XCONSOLE_SEM, 0, XCONSOLE_SEM, 0, row_XCONSOLE_SEM
XCONSOLE_SEM
        str     x20, [x22, #-8]!
        adrp    x20, sem_console
        add     x20, x20, sem_console
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XDICT_SEM DCB "DICT-SEM", 0
hl_XDICT_SEM DCB "DICT-SEM ( -- addr ) semaphore for dictionary mutation (1 = free)", 0
        BOOT_ROW nm_XDICT_SEM, hl_XDICT_SEM, 0, XDICT_SEM, 0, row_XDICT_SEM
XDICT_SEM
        str     x20, [x22, #-8]!
        adrp    x20, sem_dict
        add     x20, x20, sem_dict
        NEXT

; Running task's dictionary pointer.
; x0 = address of the DP cell, x1 = limit (one past the last byte),
; x2 = lowest legal HERE. A task with TU_DP == 0 uses here_ptr and the
; shared user dictionary. Clobbers x9 and x10. Does not touch x19–x28.
_task_dp_bounds
        mov     x10, x27
        cbnz    x10, _tdb_up
        adrp    x10, up_var
        add     x10, x10, up_var
        ldr     x10, [x10]
_tdb_up
        cbz     x10, _tdb_global
        ldr     x9, [x10, #TU_DP]
        cbz     x9, _tdb_global
        add     x0, x10, #TU_DP
        ldr     x1, [x10, #TU_DLIM]
        ldr     x2, [x10, #TU_DBASE]
        ret
_tdb_global
        adrp    x0, here_ptr
        add     x0, x0, here_ptr
        adrp    x2, user_dict_area
        add     x2, x2, user_dict_area
        adrp    x1, user_dict_size_cell
        add     x1, x1, user_dict_size_cell
        ldr     x1, [x1]
        add     x1, x2, x1
        ret

; Stop a background task that cannot compile, or abandon a console evaluate.
; Does not return. x19 must still be the instruction pointer.
_task_stop_or_abandon
        stp     x29, x30, [sp, #-16]!
        bl      _task_is_console
        cbnz    x0, _tsoa_abandon
        bl      _core_is_worker
        cbnz    x0, _tsoa_worker
        mov     x5, x27
        cbnz    x5, _tsoa_mark
        adrp    x5, up_var
        add     x5, x5, up_var
        ldr     x5, [x5]
_tsoa_mark
        str     xzr, [x5, #TU_STATUS]
        mov     x6, x19
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.ne    _tsoa_switched
        mov     x1, #-1
        str     x1, [x5, #TU_STATUS]
        mov     x19, x6
_tsoa_abandon
        b       _error_abandon
_tsoa_switched
        ldp     x29, x30, [sp], #16
        NEXT
_tsoa_worker
        ldp     x29, x30, [sp], #16
        str     xzr, [x27, #TU_STATUS]
        mov     x0, #0
        b       _core_leave

; Console, or a task whose SLICE is set, returns. Any other task prints
; and does not return. Preserves x19–x28.
_task_require_dict
        stp     x29, x30, [sp, #-16]!
        bl      _task_is_console
        cbnz    x0, _trd_ok
        mov     x10, x27
        cbnz    x10, _trd_have
        adrp    x10, up_var
        add     x10, x10, up_var
        ldr     x10, [x10]
_trd_have
        ; Null during _boot_kernel: _task_cold_init has not set UP yet.
        cbz     x10, _trd_ok
        ldr     x9, [x10, #TU_DP]
        cbnz    x9, _trd_ok
_trd_none
        adrp    x0, str_slice_none
        add     x0, x0, str_slice_none
        bl      _print_string_svc
        ldp     x29, x30, [sp], #16
        b       _task_stop_or_abandon
_trd_ok
        ldp     x29, x30, [sp], #16
        ret

; Reserve x0 bytes at HERE and align the new pointer up to 8.
; For a counted string: the bytes start at the old HERE, and the next
; cell starts aligned. Returns x0 = the old HERE. Does not return when
; the task has no slice or the bytes do not fit. Preserves x19–x28.
_here_reserve
        stp     x29, x30, [sp, #-16]!
        str     x0, [sp, #-16]!
        bl      _task_require_dict
        bl      _task_dp_bounds
        ldr     x6, [sp], #16
        mov     x5, x0
        ldr     x3, [x5]
        add     x4, x3, x6
        cmp     x4, x3
        b.lo    _hr_full
        add     x7, x4, #7
        cmp     x7, x4
        b.lo    _hr_full
        bic     x4, x7, #7
        cmp     x4, x1
        b.hi    _hr_full
        cmp     x3, x2
        b.lo    _hr_full
        str     x4, [x5]
        mov     x0, x3
        ldp     x29, x30, [sp], #16
        ret

; Reserve x0 bytes and advance HERE by exactly that many. A cell compile
; must land on old+8. Aligning here skips the CREATE data field when the
; previous ALLOT left HERE off a cell boundary, so DOES> @ reads the gap.
; Same failure and register rules as _here_reserve.
_here_reserve_exact
        stp     x29, x30, [sp, #-16]!
        str     x0, [sp, #-16]!
        bl      _task_require_dict
        bl      _task_dp_bounds
        ldr     x6, [sp], #16
        mov     x5, x0
        ldr     x3, [x5]
        add     x4, x3, x6
        cmp     x4, x3
        b.lo    _hr_full
        cmp     x4, x1
        b.hi    _hr_full
        cmp     x3, x2
        b.lo    _hr_full
        str     x4, [x5]
        mov     x0, x3
        ldp     x29, x30, [sp], #16
        ret
_hr_full
        ldp     x29, x30, [sp], #16
        adrp    x0, str_dict_full
        add     x0, x0, str_dict_full
        bl      _print_string_svc
        b       _task_stop_or_abandon

; Allot x0 bytes (a multiple of 8) at an aligned HERE, zeroed.
; Returns the address in x0. A full dictionary prints and does not return.
; The shared HERE takes DICT-SEM. A private slice does not: one task writes it.
; Clobbers x1–x7 and x9. Preserves x19–x28.
_dict_allot
        stp     x29, x30, [sp, #-16]!
        str     x0, [sp, #-16]!
        bl      _task_require_dict
        bl      _task_dp_bounds
        ldr     x6, [sp]
        adrp    x9, here_ptr
        add     x9, x9, here_ptr
        cmp     x0, x9
        b.eq    _da_lock
        mov     x7, #0
        b       _da_have_lock
_da_lock
        stp     x0, x6, [sp, #-16]!
        stp     x1, x2, [sp, #-16]!
        adrp    x0, sem_dict
        add     x0, x0, sem_dict
        bl      _core_claim_any
        ldp     x1, x2, [sp], #16
        ldp     x0, x6, [sp], #16
        mov     x7, #1
_da_have_lock
        add     sp, sp, #16
        ldr     x3, [x0]
        add     x3, x3, #7
        bic     x3, x3, #7
        add     x4, x3, x6
        cmp     x4, x3
        b.lo    _da_fail
        cmp     x4, x1
        b.hi    _da_fail
        cmp     x3, x2
        b.lo    _da_fail
        mov     x5, x3
_da_zero
        str     xzr, [x5], #8
        subs    x6, x6, #8
        b.ne    _da_zero
        str     x4, [x0]
        mov     x0, x3
        cbz     x7, _da_ret
        str     x0, [sp, #-16]!
        bl      _core_release_dict
        ldr     x0, [sp], #16
_da_ret
        ldp     x29, x30, [sp], #16
        ret
_da_fail
        cbz     x7, _da_fail_msg
        bl      _core_release_dict
_da_fail_msg
        ldp     x29, x30, [sp], #16
        adrp    x0, str_allot_over
        add     x0, x0, str_allot_over
        bl      _print_string_svc
        b       _task_stop_or_abandon

; Park on the thread in x6, the same way WAIT does.
; Returns only when this task stays. x19 is kept (or restored). A switch
; NEXTs from here and does not return. Clobbers x0, x1, x5, x21.
_task_park_fail
        stp     x29, x30, [sp, #-16]!
        mov     x21, x6
        bl      _core_wait_self
        cbz     x0, _tpf_coop
        mov     x0, #1
        ldp     x29, x30, [sp], #16
        ret
_tpf_coop
        bl      _task_can_switch
        cbz     x0, _tpf_noswitch
        adrp    x5, up_var
        add     x5, x5, up_var
        ldr     x5, [x5]
        str     x19, [x5, #TU_RESUME]
        mov     x19, x21
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.eq    _tpf_stayed
        ldp     x29, x30, [sp], #16
        NEXT
_tpf_stayed
        ldr     x19, [x5, #TU_RESUME]
_tpf_noswitch
        mov     x0, #0
        ldp     x29, x30, [sp], #16
        ret

; Mailbox and one-producer, one-consumer ring. Allotted once. Later sends
; do not move HERE. The value (or slot) store happens before the release
; store. >Q / Q> are single-producer and single-consumer: a second producer
; or consumer takes a semaphore around reserving the slot. Parking uses
; TU_RESUME, the same cell KEY and WAIT use. A task does not call these
; from inside KEY or WAIT.

        AREA |.bwstr|, DATA, READONLY
nm_XMAILBOX DCB "MAILBOX", 0
hl_XMAILBOX DCB "MAILBOX ( -- addr ) allot a value and a full/empty pair", 0
        BOOT_ROW nm_XMAILBOX, hl_XMAILBOX, 0, XMAILBOX, XMAILBOX_END, row_XMAILBOX
XMAILBOX
        str     x20, [x22, #-8]!
        mov     x0, #MB_BYTES
        bl      _dict_allot
        mov     x1, #1
        str     x1, [x0, #MB_EMPTY]
        mov     x20, x0
XMAILBOX_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XMBOX_PUT DCB ">MBOX", 0
hl_XMBOX_PUT DCB ">MBOX ( n addr -- ) store n when the mailbox is empty, then signal full", 0
        BOOT_ROW nm_XMBOX_PUT, hl_XMBOX_PUT, 0, XMBOX_PUT, XMBOX_PUT_END, row_XMBOX_PUT
XMBOX_PUT_RETRY
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        ldr     x19, [x0, #TU_RESUME]
        b       XMBOX_PUT
XMBOX_PUT
        add     x0, x20, #MB_EMPTY
_mb_put_try
        ldaxr   x1, [x0]
        cbz     x1, _mb_put_busy
        stlxr   w2, xzr, [x0]
        cbnz    w2, _mb_put_try
        ldr     x1, [x22]
        str     x1, [x20, #MB_VALUE]
        mov     x1, #1
        add     x0, x20, #MB_FULL
        stlr    x1, [x0]
        add     x22, x22, #8
        ldr     x20, [x22], #8
        bl      _core_wake
        b       XMBOX_PUT_END
_mb_put_busy
        clrex
        adrp    x6, mbox_put_thread
        add     x6, x6, mbox_put_thread
        bl      _task_park_fail
        cbnz    x0, XMBOX_PUT
        add     x22, x22, #8
        ldr     x20, [x22], #8
        adrp    x0, str_mbox_put_stuck
        add     x0, x0, str_mbox_put_stuck
        bl      _print_string_svc
XMBOX_PUT_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XMBOX_GET DCB "MBOX>", 0
hl_XMBOX_GET DCB "MBOX> ( addr -- n ) wait until full, read n, then signal empty", 0
        BOOT_ROW nm_XMBOX_GET, hl_XMBOX_GET, 0, XMBOX_GET, XMBOX_GET_END, row_XMBOX_GET
XMBOX_GET_RETRY
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        ldr     x19, [x0, #TU_RESUME]
        b       XMBOX_GET
XMBOX_GET
        add     x0, x20, #MB_FULL
_mb_get_try
        ldaxr   x1, [x0]
        cbz     x1, _mb_get_busy
        stlxr   w2, xzr, [x0]
        cbnz    w2, _mb_get_try
        ldr     x1, [x20, #MB_VALUE]
        mov     x3, #1
        add     x0, x20, #MB_EMPTY
        stlr    x3, [x0]
        mov     x20, x1
        bl      _core_wake
        b       XMBOX_GET_END
_mb_get_busy
        clrex
        adrp    x6, mbox_get_thread
        add     x6, x6, mbox_get_thread
        bl      _task_park_fail
        cbnz    x0, XMBOX_GET
        mov     x20, #0
        adrp    x0, str_mbox_get_stuck
        add     x0, x0, str_mbox_get_stuck
        bl      _print_string_svc
XMBOX_GET_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XQUEUE DCB "QUEUE", 0
hl_XQUEUE DCB "QUEUE ( n -- addr ) allot a fixed ring of n slots (n >= 2)", 0
        BOOT_ROW nm_XQUEUE, hl_XQUEUE, 0, XQUEUE, XQUEUE_END, row_XQUEUE
XQUEUE
        cmp     x20, #2
        b.lt    _queue_bad_n
        lsr     x1, x20, #61
        cbnz    x1, _queue_overflow
        lsl     x0, x20, #3
        adds    x0, x0, #Q_SLOTS
        b.cs    _queue_overflow
        mov     x21, x20
        bl      _dict_allot
        str     x21, [x0, #Q_CAP]
        mov     x20, x0
        b       XQUEUE_END
_queue_bad_n
        ldr     x20, [x22], #8
        adrp    x0, str_queue_n
        add     x0, x0, str_queue_n
        bl      _print_string_svc
        b       XQUEUE_END
_queue_overflow
        adrp    x0, str_allot_over
        add     x0, x0, str_allot_over
        bl      _print_string_svc
        b       _error_abandon
XQUEUE_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XQPUT DCB ">Q", 0
hl_XQPUT DCB ">Q ( n addr -- ) write n into the ring, then publish the tail", 0
        BOOT_ROW nm_XQPUT, hl_XQPUT, 0, XQPUT, XQPUT_END, row_XQPUT
XQPUT_RETRY
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        ldr     x19, [x0, #TU_RESUME]
        b       XQPUT
XQPUT
        ldr     x1, [x20, #Q_CAP]
        ldr     x3, [x20, #Q_TAIL]
        add     x0, x20, #Q_HEAD
        ldar    x4, [x0]
        add     x5, x3, #1
        cmp     x5, x1
        b.lo    _qput_nowrap
        mov     x5, #0
_qput_nowrap
        cmp     x5, x4
        b.eq    _qput_full
        add     x0, x20, #Q_SLOTS
        lsl     x4, x3, #3
        ldr     x1, [x22]
        str     x1, [x0, x4]
        add     x0, x20, #Q_TAIL
        stlr    x5, [x0]
        add     x22, x22, #8
        ldr     x20, [x22], #8
        bl      _core_wake
        b       XQPUT_END
_qput_full
        adrp    x6, qput_thread
        add     x6, x6, qput_thread
        bl      _task_park_fail
        cbnz    x0, XQPUT
        add     x22, x22, #8
        ldr     x20, [x22], #8
        adrp    x0, str_qput_stuck
        add     x0, x0, str_qput_stuck
        bl      _print_string_svc
XQPUT_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XQGET DCB "Q>", 0
hl_XQGET DCB "Q> ( addr -- n ) acquire the tail, read n, then publish the head", 0
        BOOT_ROW nm_XQGET, hl_XQGET, 0, XQGET, XQGET_END, row_XQGET
XQGET_RETRY
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        ldr     x19, [x0, #TU_RESUME]
        b       XQGET
XQGET
        ldr     x1, [x20, #Q_CAP]
        ldr     x3, [x20, #Q_HEAD]
        add     x0, x20, #Q_TAIL
        ldar    x4, [x0]
        cmp     x3, x4
        b.eq    _qget_empty
        add     x0, x20, #Q_SLOTS
        lsl     x5, x3, #3
        ldr     x6, [x0, x5]
        add     x5, x3, #1
        cmp     x5, x1
        b.lo    _qget_nowrap
        mov     x5, #0
_qget_nowrap
        add     x0, x20, #Q_HEAD
        stlr    x5, [x0]
        mov     x20, x6
        bl      _core_wake
        b       XQGET_END
_qget_empty
        adrp    x6, qget_thread
        add     x6, x6, qget_thread
        bl      _task_park_fail
        cbnz    x0, XQGET
        mov     x20, #0
        adrp    x0, str_qget_stuck
        add     x0, x0, str_qget_stuck
        bl      _print_string_svc
XQGET_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XQDEPTH DCB "Q-DEPTH", 0
hl_XQDEPTH DCB "Q-DEPTH ( addr -- n ) cells waiting in a ring", 0
        BOOT_ROW nm_XQDEPTH, hl_XQDEPTH, 0, XQDEPTH, XQDEPTH_END, row_XQDEPTH
XQDEPTH
        ldr     x1, [x20, #Q_CAP]
        cbz     x1, _qd_zero
        add     x0, x20, #Q_HEAD
        ldar    x3, [x0]
        add     x0, x20, #Q_TAIL
        ldar    x4, [x0]
        sub     x0, x4, x3
        cmp     x0, #0
        b.ge    _qd_pos
        add     x0, x0, x1
_qd_pos
        mov     x20, x0
        b       XQDEPTH_END
_qd_zero
        mov     x20, #0
XQDEPTH_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XCONSOLE_Q DCB "(CONSOLE?)", 0
hl_XCONSOLE_Q DCB "(CONSOLE?) ( -- flag ) true when the running task is the console", 0
        BOOT_ROW nm_XCONSOLE_Q, hl_XCONSOLE_Q, 0, XCONSOLE_Q, XCONSOLE_Q_END, row_XCONSOLE_Q
XCONSOLE_Q
        bl      _task_is_console
        str     x20, [x22, #-8]!
        mov     x20, #-1
        cbnz    x0, XCONSOLE_Q_END
        mov     x20, #0
XCONSOLE_Q_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XSTOP DCB "STOP", 0
hl_XSTOP DCB "STOP ( -- ) sleep the running task and yield", 0
        BOOT_ROW nm_XSTOP, hl_XSTOP, 0, XSTOP, XSTOP_END, row_XSTOP
XSTOP
        bl      _core_is_worker
        cbz     x0, _stop_coop
        str     xzr, [x27, #TU_STATUS]
        mov     x0, #0
        b       _core_leave
_stop_coop
        adrp    x5, up_var
        add     x5, x5, up_var
        ldr     x5, [x5]
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x5, x1
        b.eq    _stop_console
        mov     x6, x19
        str     xzr, [x5, #TU_STATUS]
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.ne    XSTOP_END
        mov     x1, #-1
        str     x1, [x5, #TU_STATUS]
        mov     x19, x6
        b       XSTOP_END
_stop_console
        adrp    x0, str_stop_console
        add     x0, x0, str_stop_console
        bl      _print_string_svc
XSTOP_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XSLEEP DCB "SLEEP", 0
hl_XSLEEP DCB "SLEEP ( task -- ) mark a task asleep; yield if it is current", 0
        BOOT_ROW nm_XSLEEP, hl_XSLEEP, 0, XSLEEP, XSLEEP_END, row_XSLEEP
XSLEEP
        adrp    x1, up_var
        add     x1, x1, up_var
        ldr     x1, [x1]
        cmp     x20, x1
        b.eq    _sleep_self
        mov     x5, x20
        ldr     x20, [x22], #8
        str     xzr, [x5, #TU_STATUS]
        b       XSLEEP_END
_sleep_self
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x20, x1
        b.ne    _sleep_self_ok
        bl      _task_other_awake
        cbnz    x0, _sleep_self_ok
        ldr     x20, [x22], #8 ; drop the task address
        adrp    x0, str_sleep_only
        add     x0, x0, str_sleep_only
        bl      _print_string_svc
        b       XSLEEP_END
_sleep_self_ok
        mov     x5, x20
        ldr     x20, [x22], #8
        str     xzr, [x5, #TU_STATUS]
        bl      _task_yield
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
        cmp     x0, x5
        b.ne    XSLEEP_END
        mov     x1, #-1
        str     x1, [x5, #TU_STATUS]
XSLEEP_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XWAKE DCB "WAKE", 0
hl_XWAKE DCB "WAKE ( task -- ) mark a task awake", 0
        BOOT_ROW nm_XWAKE, hl_XWAKE, 0, XWAKE, XWAKE_END, row_XWAKE
XWAKE
        mov     x5, x20
        ldr     x20, [x22], #8
        mov     x1, #-1
        str     x1, [x5, #TU_STATUS]
XWAKE_END
        NEXT

        AREA |.bwstr|, DATA, READONLY
nm_XACTIVATE DCB "ACTIVATE", 0
hl_XACTIVATE DCB "ACTIVATE ( task -- ) run the following colon body as that task", 0
        BOOT_ROW nm_XACTIVATE, hl_XACTIVATE, 0, XACTIVATE, XACTIVATE_END, row_XACTIVATE
XACTIVATE
        adrp    x1, restart_cell
        add     x1, x1, restart_cell
        cmp     x19, x1
        b.eq    _act_interp
        adrp    x1, up_var
        add     x1, x1, up_var
        ldr     x1, [x1]
        cmp     x20, x1
        b.eq    _act_self
        mov     x0, x20
        ldr     x20, [x22], #8
        str     x19, [x0, #TU_IP]
        str     xzr, [x0, #TU_TOS]
        ldr     x1, [x0, #TU_S0]
        str     x1, [x0, #TU_DSP]
        ldr     x1, [x0, #TU_R0]
        sub     x2, x1, #8
        adrp    x3, task_stop_thread
        add     x3, x3, task_stop_thread
        str     x3, [x2]
        str     x2, [x0, #TU_RSP]
        adrp    x1, base_var
        add     x1, x1, base_var
        ldr     x1, [x1]
        str     x1, [x0, #TU_BASE]
        str     xzr, [x0, #TU_STATE]
        ; Fresh SOURCE. Pointers stay; the body does not parse the console.
        mov     x1, #TU_SRC_ADDR
_act_clr_src
        str     xzr, [x0, x1]
        add     x1, x1, #8
        cmp     x1, #TU_WORD_PTR
        b.lo    _act_clr_src
        mov     x1, #-1
        str     x1, [x0, #TU_STATUS]
        ldr     x19, [x23], #8
        adrp    x1, cores_var
        add     x1, x1, cores_var
        ldr     x1, [x1]
        cbz     x1, XACTIVATE_END
        adrp    x1, core_schedule_hook
        add     x1, x1, core_schedule_hook
        ldr     x1, [x1]
        cbz     x1, XACTIVATE_END
        blr     x1
        b       XACTIVATE_END
_act_interp
        adrp    x0, str_act_interp
        add     x0, x0, str_act_interp
        bl      _print_string_svc
        b       _error_abandon
_act_self
        adrp    x0, str_act_self
        add     x0, x0, str_act_self
        bl      _print_string_svc
        b       _error_abandon
XACTIVATE_END
        NEXT

; (TASK-INIT) ( -- )  allot and link a task at HERE. Used by TASK: after CREATE.
        AREA |.bwstr|, DATA, READONLY
nm_XTASK_INIT DCB "(TASK-INIT)", 0
hl_XTASK_INIT DCB "(TASK-INIT) ( -- ) allot user area and stacks at HERE and link the task", 0
        BOOT_ROW nm_XTASK_INIT, hl_XTASK_INIT, 0, XTASK_INIT, XTASK_INIT_END, row_XTASK_INIT
XTASK_INIT
        stp     x29, x30, [sp, #-16]!
        bl      _task_require_dict
        bl      _task_dp_bounds
        mov     x7, x0
        ldr     x0, [x7]
        mov     x6, #TASK_ALLOT ; 11736 does not fit in an add immediate
        add     x4, x0, x6
        cmp     x4, x0
        b.lo    _task_allot_fail
        cmp     x4, x1
        b.hi    _task_allot_fail
        mov     x5, x0
_task_zero
        str     xzr, [x5], #8
        subs    x6, x6, #8
        b.ne    _task_zero
        str     x4, [x7]
        ldp     x29, x30, [sp], #16
        add     x5, x0, #TU_BYTES
        add     x5, x5, #1, lsl #12
        str     x5, [x0, #TU_S0]
        str     x5, [x0, #TU_DSP]
        add     x5, x5, #1, lsl #12
        str     x5, [x0, #TU_R0]
        str     x5, [x0, #TU_RSP]
        ; Private scratch sits after the two stacks. x5 is that base (R0).
        str     x5, [x0, #TU_WORD_PTR]
        add     x5, x5, #TASK_WORD_BYTES
        str     x5, [x0, #TU_PAD_PTR]
        add     x5, x5, #TASK_PAD_BYTES
        str     x5, [x0, #TU_INPUT_PTR]
        add     x5, x5, #TASK_INPUT_BYTES
        str     x5, [x0, #TU_SSTK_PTR]
        add     x5, x5, #TASK_SRCSTK_BYTES
        str     x5, [x0, #TU_EVALSTK_PTR]
        adrp    x5, base_var
        add     x5, x5, base_var
        ldr     x5, [x5]
        str     x5, [x0, #TU_BASE]
        adrp    x5, XKEY_RETRY
        add     x5, x5, XKEY_RETRY
        str     x5, [x0, #TU_RETRY_XT]
        add     x5, x0, #TU_RETRY_XT
        str     x5, [x0, #TU_RETRY_LIST]
        adrp    x5, console_task
        add     x5, x5, console_task
        ldr     x6, [x5, #TU_LINK]
        cbnz    x6, _task_link
        mov     x6, x5
_task_link
        str     x6, [x0, #TU_LINK]
        str     x0, [x5, #TU_LINK]
        b       XTASK_INIT_END
_task_allot_fail
        ldp     x29, x30, [sp], #16
        adrp    x0, str_allot_over
        add     x0, x0, str_allot_over
        bl      _print_string_svc
        b       _task_stop_or_abandon
XTASK_INIT_END
        NEXT

; SLICE ( n task -- )  Console only. Allot n bytes from the shared HERE and
; record that region as the task's dictionary. The task must be asleep and
; must not already have a slice. Console HERE moves past the slice.
        AREA |.bwstr|, DATA, READONLY
nm_XSLICE DCB "SLICE", 0
hl_XSLICE DCB "SLICE ( n task -- ) reserve n bytes as that task's private dictionary", 0
        BOOT_ROW nm_XSLICE, hl_XSLICE, 0, XSLICE, XSLICE_END, row_XSLICE
XSLICE
        adrp    x1, console_task
        add     x1, x1, console_task
        cmp     x27, x1
        b.eq    _xslice_ok
        adrp    x0, str_slice_console
        add     x0, x0, str_slice_console
        bl      _print_string_svc
        b       XSTOP
_xslice_ok
        mov     x9, x20
        ldr     x8, [x22], #8
        ldr     x20, [x22], #8
        tst     x9, #7
        b.ne    _xslice_bad
        cmp     x9, x1
        b.eq    _xslice_bad
        adrp    x2, user_dict_area
        add     x2, x2, user_dict_area
        cmp     x9, x2
        b.lo    _xslice_bad
        adrp    x2, here_ptr
        add     x2, x2, here_ptr
        ldr     x2, [x2]
        cmp     x9, x2
        b.hs    _xslice_bad
        ldr     x2, [x9, #TU_STATUS]
        cbnz    x2, _xslice_bad
        ldr     x2, [x9, #TU_DP]
        cbnz    x2, _xslice_bad
        cmp     x8, #1
        b.lt    _xslice_bad
        ; A size past the current dictionary end fails in _dict_allot.
        ; USER_DICT_MAX does not fit in a mov or cmp immediate.
        add     x8, x8, #7
        bic     x8, x8, #7
        stp     x29, x30, [sp, #-16]!
        stp     x8, x9, [sp, #-16]!
        mov     x0, x8
        bl      _dict_allot
        ldp     x8, x9, [sp], #16
        str     x0, [x9, #TU_DBASE]
        str     x0, [x9, #TU_DP]
        add     x1, x0, x8
        str     x1, [x9, #TU_DLIM]
        ldp     x29, x30, [sp], #16
        NEXT
_xslice_bad
        adrp    x0, str_slice_bad
        add     x0, x0, str_slice_bad
        bl      _print_string_svc
        b       _error_abandon
XSLICE_END

; x1 unused. Cut is forget_cut. Unlink dictionary tasks at or above the cut.
_task_forget_cut
        adrp    x12, forget_cut
        add     x12, x12, forget_cut
        ldr     x12, [x12]
        adrp    x10, console_task
        add     x10, x10, console_task
        mov     x11, x10
        ldr     x13, [x10, #TU_LINK]
_tf_loop
        cbz     x13, _tf_done
        cmp     x13, x10
        b.eq    _tf_done
        ldr     x14, [x13, #TU_LINK]
        cmp     x13, x12
        b.lo    _tf_keep
        str     x14, [x11, #TU_LINK]
        adrp    x16, up_var
        add     x16, x16, up_var
        ldr     x17, [x16]
        cmp     x17, x13
        b.ne    _tf_next
        str     x10, [x16]
        mov     x27, x10
_tf_next
        mov     x13, x14
        b       _tf_loop
_tf_keep
        ; A cut inside this task's slice must not leave TU_DP past the new HERE.
        ldr     x15, [x13, #TU_DP]
        cbz     x15, _tf_keep_link
        ldr     x16, [x13, #TU_DBASE]
        ldr     x17, [x13, #TU_DLIM]
        cmp     x17, x12
        b.ls    _tf_keep_link
        cmp     x16, x12
        b.hs    _tf_slice_clear
        cmp     x15, x12
        b.ls    _tf_slice_lim
        str     x12, [x13, #TU_DP]
_tf_slice_lim
        str     x12, [x13, #TU_DLIM]
        b       _tf_keep_link
_tf_slice_clear
        str     xzr, [x13, #TU_DBASE]
        str     xzr, [x13, #TU_DP]
        str     xzr, [x13, #TU_DLIM]
_tf_keep_link
        mov     x11, x13
        mov     x13, x14
        b       _tf_loop
_tf_done
        ret

; Fill the console task from the live stacks. Called from cold start.
_task_cold_init
        adrp    x0, console_task
        add     x0, x0, console_task
        str     x0, [x0, #TU_LINK]
        mov     x1, #-1
        str     x1, [x0, #TU_STATUS]
        str     xzr, [x0, #TU_IP]
        str     xzr, [x0, #TU_TOS]
        str     x22, [x0, #TU_DSP]
        str     x23, [x0, #TU_RSP]
        adrp    x1, data_stack
        add     x1, x1, data_stack
        add     x1, x1, #1, lsl #12
        str     x1, [x0, #TU_S0]
        adrp    x1, return_stack
        add     x1, x1, return_stack
        add     x1, x1, #1, lsl #12
        str     x1, [x0, #TU_R0]
        mov     x1, #10
        str     x1, [x0, #TU_BASE]
        str     xzr, [x0, #TU_STATE]
        str     xzr, [x0, #TU_RESUME]
        adrp    x1, XKEY_RETRY
        add     x1, x1, XKEY_RETRY
        str     x1, [x0, #TU_RETRY_XT]
        add     x1, x0, #TU_RETRY_XT
        str     x1, [x0, #TU_RETRY_LIST]
        adrp    x1, up_var
        add     x1, x1, up_var
        str     x0, [x1]
        adrp    x1, multi_var
        add     x1, x1, multi_var
        str     xzr, [x1]
        ; Console scratch is the existing BSS buffers. Same addresses as before.
        adrp    x1, word_scratch
        add     x1, x1, word_scratch
        str     x1, [x0, #TU_WORD_PTR]
        adrp    x1, pad_buffer
        add     x1, x1, pad_buffer
        str     x1, [x0, #TU_PAD_PTR]
        adrp    x1, input_buffer
        add     x1, x1, input_buffer
        str     x1, [x0, #TU_INPUT_PTR]
        adrp    x1, source_stack
        add     x1, x1, source_stack
        str     x1, [x0, #TU_SSTK_PTR]
        adrp    x1, eval_resume_stack
        add     x1, x1, eval_resume_stack
        str     x1, [x0, #TU_EVALSTK_PTR]
        str     xzr, [x0, #TU_DBASE]
        str     xzr, [x0, #TU_DP]
        str     xzr, [x0, #TU_DLIM]
        mov     x1, #1
        adrp    x2, sem_graphics
        add     x2, x2, sem_graphics
        str     x1, [x2]
        adrp    x2, sem_console
        add     x2, x2, sem_console
        str     x1, [x2]
        adrp    x2, sem_dict
        add     x2, x2, sem_dict
        str     x1, [x2]
        adrp    x1, cores_var
        add     x1, x1, cores_var
        str     xzr, [x1]
        adrp    x1, core_task
        add     x1, x1, core_task
        mov     x2, #CORE_SLOTS
Ltc_zap_task
        str     xzr, [x1], #8
        subs    x2, x2, #1
        b.ne    Ltc_zap_task
        adrp    x1, core_pthread
        add     x1, x1, core_pthread
        mov     x2, #CORE_SLOTS
Ltc_zap_pthread
        str     xzr, [x1], #8
        subs    x2, x2, #1
        b.ne    Ltc_zap_pthread
        mov     x27, x0
        ret
_core_leave
        mov     x21, x0
        cbz     x27, _cl_noslot
        mov     x10, #0
        adrp    x9, core_task
        add     x9, x9, core_task
_cl_scan
        ldr     x11, [x9, x10, lsl #3]
        cmp     x11, x27
        b.eq    _cl_hit
        add     x10, x10, #1
        cmp     x10, #CORE_SLOTS
        b.lo    _cl_scan
_cl_noslot
        NEXT
_cl_hit
        str     x19, [x27, #TU_IP]
        str     x20, [x27, #TU_TOS]
        str     x22, [x27, #TU_DSP]
        str     x23, [x27, #TU_RSP]
        str     xzr, [x9, x10, lsl #3]
        adrp    x11, core_pthread
        add     x11, x11, core_pthread
        str     xzr, [x11, x10, lsl #3]
        adrp    x11, core_sp
        add     x11, x11, core_sp
        ldr     x11, [x11, x10, lsl #3]
        mov     sp, x11
        mov     x0, x21
        b       _ktr_epilogue

; x0 = 1 when x27 is a live worker slot. Preserves x9 and x19-x28.
_core_is_worker
        cbz     x27, _ciw_no
        adrp    x1, core_task
        add     x1, x1, core_task
        mov     x2, #0
_ciw_loop
        ldr     x3, [x1, x2, lsl #3]
        cmp     x3, x27
        b.eq    _ciw_yes
        add     x2, x2, #1
        cmp     x2, #CORE_SLOTS
        b.lo    _ciw_loop
_ciw_no
        mov     x0, #0
        ret
_ciw_yes
        mov     x0, #1
        ret

; Park this task. Returns 1 after the wait hook. Returns 0 when CORES is
; off or the hook is missing. Preserves x9 and x19-x28.
_core_wait_self
        stp     x29, x30, [sp, #-16]!
        stp     x9, x10, [sp, #-16]!
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _cws_none
        adrp    x10, core_wait_hook
        add     x10, x10, core_wait_hook
        ldr     x10, [x10]
        cbz     x10, _cws_none
        mov     x0, x27
        blr     x10
        mov     x0, #1
        b       _cws_out
_cws_none
        mov     x0, #0
_cws_out
        ldp     x9, x10, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

; Wake every parked CORES task. No-op while CORES is off.
_core_wake
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _cw_fast
        adrp    x10, core_wake_hook
        add     x10, x10, core_wake_hook
        ldr     x10, [x10]
        cbz     x10, _cw_fast
        stp     x29, x30, [sp, #-16]!
        blr     x10
        ldp     x29, x30, [sp], #16
_cw_fast
        ret

_core_join_call
        stp     x29, x30, [sp, #-16]!
        adrp    x0, core_join_hook
        add     x0, x0, core_join_hook
        ldr     x0, [x0]
        cbz     x0, _cjn_none
        blr     x0
_cjn_none
        ldp     x29, x30, [sp], #16
        ret

; x0 = semaphore. No-op while CORES is off. Includes the console.
_core_claim_any
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _cca_fast
        stp     x29, x30, [sp, #-16]!
        mov     x9, x0
_cca_try
        ldaxr   x1, [x9]
        cbz     x1, _cca_busy
        stlxr   w2, xzr, [x9]
        cbnz    w2, _cca_try
        ldp     x29, x30, [sp], #16
_cca_fast
        ret
_cca_busy
        clrex
        bl      _core_wait_self
        cbnz    x0, _cca_try
        bl      _core_is_worker
        cbz     x0, _cca_abandon
        ldp     x29, x30, [sp], #16
        str     xzr, [x27, #TU_STATUS]
        mov     x0, #0
        b       _core_leave
_cca_abandon
        b       _error_abandon

; x0 = semaphore. Workers only. The console does not take it.
_core_claim_worker
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _ccw_fast
        stp     x29, x30, [sp, #-16]!
        stp     x9, x8, [sp, #-16]!
        mov     x9, x0
        bl      _core_is_worker
        cbz     x0, _ccw_pop
_ccw_try
        ldaxr   x1, [x9]
        cbz     x1, _ccw_busy
        stlxr   w2, xzr, [x9]
        cbnz    w2, _ccw_try
_ccw_pop
        ldp     x9, x8, [sp], #16
        ldp     x29, x30, [sp], #16
_ccw_fast
        ret
_ccw_busy
        clrex
        bl      _core_wait_self
        cbnz    x0, _ccw_try
        ldp     x9, x8, [sp], #16
        ldp     x29, x30, [sp], #16
        str     xzr, [x27, #TU_STATUS]
        mov     x0, #0
        b       _core_leave

; x0 = semaphore. No-op while CORES is off.
_core_release_any
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _cra_fast
        mov     x9, x0
        mov     x1, #1
        stlr    x1, [x9]
        b       _core_wake
_cra_fast
        ret

_core_release_dict
        ; Callers such as _dict_allot return the allotted address in x0.
        stp     x29, x30, [sp, #-16]!
        str     x0, [sp, #-16]!
        adrp    x0, sem_dict
        add     x0, x0, sem_dict
        bl      _core_release_any
        ldr     x0, [sp], #16
        ldp     x29, x30, [sp], #16
        ret

; x0 = semaphore. Workers only.
_core_release_worker
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _crw_fast
        stp     x29, x30, [sp, #-16]!
        mov     x9, x0
        bl      _core_is_worker
        cbz     x0, _crw_pop
        mov     x1, #1
        stlr    x1, [x9]
        bl      _core_wake
_crw_pop
        ldp     x29, x30, [sp], #16
_crw_fast
        ret

; Refuse compile and parse words on a live worker while CORES is on.
; Cooperative sessions return without printing. A worker does not return.
_core_console_only
        adrp    x10, cores_var
        add     x10, x10, cores_var
        ldr     x10, [x10]
        cbz     x10, _cco_fast
        adrp    x10, console_task
        add     x10, x10, console_task
        cmp     x27, x10
        b.eq    _cco_fast
        cbz     x27, _cco_fast
        stp     x29, x30, [sp, #-16]!
        bl      _core_is_worker
        cbz     x0, _cco_pop
        adrp    x0, str_cores_word
        add     x0, x0, str_cores_word
        bl      _print_string_svc
        ldp     x29, x30, [sp], #16
        str     xzr, [x27, #TU_STATUS]
        mov     x0, #0
        b       _core_leave
_cco_pop
        ldp     x29, x30, [sp], #16
_cco_fast
        ret
        AREA |.bwstr|, DATA, READONLY
nm_XHLD DCB "HLD", 0
hl_XHLD DCB "HLD ( -- addr ) pictured numeric output pointer for this task", 0
        BOOT_ROW nm_XHLD, hl_XHLD, 0, XHLD, XHLD_END, row_XHLD
XHLD
        str     x20, [x22, #-8]!
        mov     x0, x27
        cbnz    x0, _xhld_up
        adrp    x0, up_var
        add     x0, x0, up_var
        ldr     x0, [x0]
_xhld_up
        add     x0, x0, #TU_HLD
        mov     x20, x0
XHLD_END
        NEXT

; Worker entry. C stores the thread id in core_pthread[slot] first.
; The 112-byte frame matches the Mac kernel_task_run epilogue that
; _core_leave returns through. The first dispatch skips the debug gate.
; ENDP stays after both returns so the x64 translation uses a hardware ret.
kernel_task_enter PROC
        cbz     x0, _ktr_bad
        cmp     w1, #(CORE_SLOTS - 1)
        b.hi    _ktr_bad
        uxtw    x1, w1
        stp     x29, x30, [sp, #-112]!
        mov     x29, sp
        stp     x19, x20, [sp, #16]
        stp     x21, x22, [sp, #32]
        stp     x23, x24, [sp, #48]
        stp     x25, x26, [sp, #64]
        stp     x27, x28, [sp, #80]
        str     x0, [sp, #96]
        str     x1, [sp, #104]
        mov     x19, x0
        mov     x20, x1
        adrp    x2, core_sp
        add     x2, x2, core_sp
        mov     x3, sp
        str     x3, [x2, x20, lsl #3]
        adrp    x2, core_task
        add     x2, x2, core_task
        str     x19, [x2, x20, lsl #3]
        mov     x27, x19
        mov     x28, #0
        ldr     x19, [x27, #TU_IP]
        ldr     x20, [x27, #TU_TOS]
        ldr     x22, [x27, #TU_DSP]
        ldr     x23, [x27, #TU_RSP]
        adrp    x24, latest_var
        add     x24, x24, latest_var
        ldr     x21, [x19], #8
        ldr     x1, [x21]
        br      x1

; Memory fault in this worker. The host sets SP to the entry frame.
; Clear the task and the slot, then return -1 through that frame.
ktr_fault_resume
        ldr     x27, [sp, #96]
        ldr     x1, [sp, #104]
        adrp    x2, core_task
        add     x2, x2, core_task
        str     xzr, [x2, x1, lsl #3]
        adrp    x2, core_pthread
        add     x2, x2, core_pthread
        str     xzr, [x2, x1, lsl #3]
        adrp    x2, core_sp
        add     x2, x2, core_sp
        str     xzr, [x2, x1, lsl #3]
        cbz     x27, _ktr_fault_go
        str     xzr, [x27, #TU_STATUS]
_ktr_fault_go
        mov     x0, #-1
        b       _ktr_epilogue

_ktr_epilogue
        ldp     x19, x20, [sp, #16]
        ldp     x21, x22, [sp, #32]
        ldp     x23, x24, [sp, #48]
        ldp     x25, x26, [sp, #64]
        ldp     x27, x28, [sp, #80]
        ldp     x29, x30, [sp], #112
        ret
_ktr_bad
        mov     x0, #-2
        ret
        ENDP

; Session-staying abandon. The eval frame SP was saved at entry.
; Returns 0 through _do_quit. A worker never reaches this label.
_error_abandon
        adrp    x16, eval_frame_sp
        add     x16, x16, eval_frame_sp
        ldr     x16, [x16]
        mov     sp, x16
        b       _do_quit

_kernel_set_key_q
kernel_set_key_q PROC
        adrp    x1, key_q_hook
        add     x1, x1, key_q_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_set_core_schedule
kernel_set_core_schedule PROC
        adrp    x1, core_schedule_hook
        add     x1, x1, core_schedule_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_set_core_wait
kernel_set_core_wait PROC
        adrp    x1, core_wait_hook
        add     x1, x1, core_wait_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_set_core_wake
kernel_set_core_wake PROC
        adrp    x1, core_wake_hook
        add     x1, x1, core_wake_hook
        str     x0, [x1]
        ret
        ENDP

_kernel_set_core_join
kernel_set_core_join PROC
        adrp    x1, core_join_hook
        add     x1, x1, core_join_hook
        str     x0, [x1]
        ret
        ENDP

next_debug_gate
        adrp    x16, next_debug
        add     x16, x16, next_debug
        br      x16


        AREA |.rdata|, DATA, READONLY

str_act_interp DCB "ACTIVATE is only valid inside a colon definition", 10, 0
str_act_self DCB "ACTIVATE: a task cannot activate itself", 10, 0
str_allot_over DCB "ALLOT: dictionary full (need more USER-DICT space)", 10, 0
str_allot_under DCB "ALLOT: below dictionary start", 10, 0
str_cores_console DCB "? CORES only from the console task", 10, 0
str_cores_word DCB "? CORES: console only", 10, 0
str_dict_full DCB "dictionary full (code/data space exhausted)", 10, 0
str_mbox_get_stuck DCB "? MBOX>: no other task can send", 10, 0
str_mbox_put_stuck DCB "? >MBOX: no other task can receive", 10, 0
str_qget_stuck DCB "? Q>: no other task can send", 10, 0
str_qput_stuck DCB "? >Q: no other task can receive", 10, 0
str_queue_n DCB "? QUEUE: need at least 2 slots", 10, 0
str_sleep_only DCB "SLEEP: the console is the only awake task", 10, 0
str_slice_bad DCB "? SLICE: sleeping task and a positive size", 10, 0
str_slice_console DCB "? SLICE only from the console task", 10, 0
str_slice_none DCB "? SLICE: task has no dictionary", 10, 0
str_stop_console DCB "STOP: the console task stays awake", 10, 0
str_wait_stuck DCB "? WAIT: no other task can SIGNAL", 10, 0

; (SOURCE!) ( c-addr u -- )  point this task's SOURCE at a string. >IN = 0.
        AREA |.bwstr|, DATA, READONLY
nm_XSOURCE_STORE DCB "(SOURCE!)", 0
hl_XSOURCE_STORE DCB "(SOURCE!) ( c-addr u -- ) set this task's SOURCE and zero >IN", 0
        BOOT_ROW nm_XSOURCE_STORE, hl_XSOURCE_STORE, 0, XSOURCE_STORE, XSOURCE_STORE_END, row_XSOURCE_STORE
XSOURCE_STORE
        stp     x29, x30, [sp, #-16]!
        mov     x1, x20
        ldr     x0, [x22], #8
        ldr     x20, [x22], #8
        bl      _set_source
        ldp     x29, x30, [sp], #16
XSOURCE_STORE_END
        NEXT

        AREA |.data|, DATA, READWRITE, ALIGN=8

console_task SPACE TU_BYTES
console_hw_sp DCQ 0
up_var       DCQ 0
multi_var    DCQ 0
cores_var    DCQ 0
console_pthread DCQ 0
stop_retry_xt DCQ XSTOP
park_retry_xt DCQ XPARK
task_stop_thread DCQ stop_retry_xt
park_thread  DCQ park_retry_xt
wait_retry_xt DCQ XWAIT_RETRY
wait_thread  DCQ wait_retry_xt
sem_graphics DCQ 1
sem_console  DCQ 1
sem_dict     DCQ 1
mbox_put_retry_xt DCQ XMBOX_PUT_RETRY
mbox_put_thread DCQ mbox_put_retry_xt
mbox_get_retry_xt DCQ XMBOX_GET_RETRY
mbox_get_thread DCQ mbox_get_retry_xt
qput_retry_xt DCQ XQPUT_RETRY
qput_thread  DCQ qput_retry_xt
qget_retry_xt DCQ XQGET_RETRY
qget_thread  DCQ qget_retry_xt
        ALIGN 8
core_sp      SPACE 80
core_task    SPACE 80
core_pthread SPACE 80
key_q_hook   DCQ 0
core_schedule_hook DCQ 0
core_wait_hook DCQ 0
core_wake_hook DCQ 0
core_join_hook DCQ 0
        ALIGN 8
input_buffer SPACE 1024
eval_frame_sp DCQ 0

        END
