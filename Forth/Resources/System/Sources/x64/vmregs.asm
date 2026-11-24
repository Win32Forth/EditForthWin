; Shared exclusive-monitor cells for the translated x64 kernel.
; The per-thread x0..x30 file and NZCV flags live in arm_tls (cores_win.c).
; r15 holds that base while translated code runs. SP is the real RSP.

OPTION CASEMAP:NONE

.DATA

PUBLIC arm_excl
PUBLIC arm_excl_addr
PUBLIC arm_excl_val

arm_excl DQ 0
arm_excl_addr DQ 0
arm_excl_val DQ 0

END
