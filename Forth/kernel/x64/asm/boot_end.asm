; Generated from Forth/kernel/arm64/boot_end.asm. Do not edit.
OPTION CASEMAP:NONE
EXTRN arm_excl:QWORD
EXTRN arm_excl_addr:QWORD
EXTRN arm_excl_val:QWORD
BOOTPTR SEGMENT ALIGN(8) READ
PUBLIC bootptr_end
bootptr_end:
BOOTPTR ENDS
END
