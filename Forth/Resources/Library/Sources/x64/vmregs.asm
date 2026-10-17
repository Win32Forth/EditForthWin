; Virtual ARM64 register file for the translated x64 kernel.
; SP is the real RSP. The generated code keeps x0-x30 here and uses only
; volatile x64 registers around them.

OPTION CASEMAP:NONE

.DATA

PUBLIC arm_x0
PUBLIC arm_x1
PUBLIC arm_x2
PUBLIC arm_x3
PUBLIC arm_x4
PUBLIC arm_x5
PUBLIC arm_x6
PUBLIC arm_x7
PUBLIC arm_x8
PUBLIC arm_x9
PUBLIC arm_x10
PUBLIC arm_x11
PUBLIC arm_x12
PUBLIC arm_x13
PUBLIC arm_x14
PUBLIC arm_x15
PUBLIC arm_x16
PUBLIC arm_x17
PUBLIC arm_x18
PUBLIC arm_x19
PUBLIC arm_x20
PUBLIC arm_x21
PUBLIC arm_x22
PUBLIC arm_x23
PUBLIC arm_x24
PUBLIC arm_x25
PUBLIC arm_x26
PUBLIC arm_x27
PUBLIC arm_x28
PUBLIC arm_x29
PUBLIC arm_x30
PUBLIC arm_n
PUBLIC arm_z
PUBLIC arm_c
PUBLIC arm_v

arm_x0  DQ 0
arm_x1  DQ 0
arm_x2  DQ 0
arm_x3  DQ 0
arm_x4  DQ 0
arm_x5  DQ 0
arm_x6  DQ 0
arm_x7  DQ 0
arm_x8  DQ 0
arm_x9  DQ 0
arm_x10 DQ 0
arm_x11 DQ 0
arm_x12 DQ 0
arm_x13 DQ 0
arm_x14 DQ 0
arm_x15 DQ 0
arm_x16 DQ 0
arm_x17 DQ 0
arm_x18 DQ 0
arm_x19 DQ 0
arm_x20 DQ 0
arm_x21 DQ 0
arm_x22 DQ 0
arm_x23 DQ 0
arm_x24 DQ 0
arm_x25 DQ 0
arm_x26 DQ 0
arm_x27 DQ 0
arm_x28 DQ 0
arm_x29 DQ 0
arm_x30 DQ 0
arm_n   DB 0
arm_z   DB 0
arm_c   DB 0
arm_v   DB 0

END
