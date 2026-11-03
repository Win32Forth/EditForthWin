; BOOT_WORD name, help, flags, code, end
; Same five-quad row as the Mac kernel: name, help, flags, code, end.
; A pointer to each row is appended to |.bootptr| for the boot walk.
; The name is substituted into a string, so the call site passes the
; characters, not a quoted token.
;
; $flags is still an argument. The macro decides how to emit it.
; Boot flags live in header bits 61-63 (INLINE, EMM, IMM). armasm64
; rejects a 64-bit DCQ literal for bit 63, so a value at or above
; INLINE's high half is stored as the high 32 bits of the flags cell.
; A smaller value is stored with DCQ, which keeps a plain 0 intact.
; FLAG_IMM / FLAG_EMM / FLAG_INLINE are those high halves and combine
; with :OR:.
;
; A semicolon, comma, backslash, or quotation mark cannot appear on a
; call line. Those names use BOOT_WORD_SEMI / _COMMA / _BSLASH /
; _SQUOTE / _SLIT / _CQUOTE / _CSTR, which still take the same flags argument.

FLAG_INLINE EQU 0x20000000
FLAG_EMM    EQU 0x40000000
FLAG_IMM    EQU 0x80000000

        MACRO
        BOOT_EMIT_FLAGS $flags
        IF ($flags) >= 0x20000000
        DCD     0, $flags
        ELSE
        DCQ     $flags
        ENDIF
        MEND

        MACRO
        BOOT_ROW $nm, $hl, $flags, $code, $end, $row
        AREA |.bootword|, DATA, READONLY, ALIGN=3
        ALIGN 8
$row    DCQ     $nm, $hl
        BOOT_EMIT_FLAGS $flags
        DCQ     $code, $end
        AREA |.bootptr|, DATA, READONLY, ALIGN=3
        ALIGN 8
        DCQ     $row
        AREA |.text|, CODE, READONLY, ALIGN=4
        MEND

        MACRO
        BOOT_WORD $name, $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "$name", 0
hl_$code DCB "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_SEMI $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB 0x3B, 0
hl_$code DCB 0x3B, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_COMMA $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB 0x2C, 0
hl_$code DCB 0x2C, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_BSLASH $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB 0x5C, 0
hl_$code DCB 0x5C, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_BS_S $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB 0x5C, "S", 0
hl_$code DCB 0x5C, "S", "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_SQUOTE $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "S", 0x22, 0
hl_$code DCB "S", 0x22, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_SLIT $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "(S", 0x22, ")", 0
hl_$code DCB "(S", 0x22, ")", "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_DOTQ $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB ".", 0x22, 0
hl_$code DCB ".", 0x22, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_SESCAPE $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "S", 0x5C, 0x22, 0
hl_$code DCB "S", 0x5C, 0x22, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_TIME_DATE $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "TIME", 0x26, "DATE", 0
hl_$code DCB "TIME", 0x26, "DATE", "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_CQUOTE $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "C", 0x22, 0
hl_$code DCB "C", 0x22, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_CSTR $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "(C", 0x22, ")", 0
hl_$code DCB "(C", 0x22, ")", "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        MACRO
        BOOT_WORD_CCOMMA $help, $flags, $code, $end
        AREA |.bwstr|, DATA, READONLY
nm_$code DCB "C", 0x2C, 0
hl_$code DCB "C", 0x2C, "$help", 0
        BOOT_ROW nm_$code, hl_$code, $flags, $code, $end, row_$code
        MEND

        END
