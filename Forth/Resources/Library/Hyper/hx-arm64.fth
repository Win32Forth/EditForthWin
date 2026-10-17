\ hx-arm64.fth — index armasm64 BOOT_WORD lines.
\
\ Call shape (commas, not quotes). A semicolon, comma, backslash, or
\ quotation mark cannot appear on a BOOT_WORD line; those names use
\ BOOT_WORD_SEMI / _COMMA / _BSLASH / _SQUOTE / and the other suffixes.
\ The indexed line is the BOOT_WORD line itself.
\
\ Loaded from hyper-index.fth into HYPER-VOC.

ONLY FORTH ALSO HYPER-VOC DEFINITIONS

\ ( a u -- a u ) drop blanks at the end
: HX-A64-RTRIM  ( a u -- a u )
   BEGIN
      DUP 0= IF  EXIT  THEN
      2DUP 1- + C@ BL <> IF  EXIT  THEN
      1-
   AGAIN ;

\ ( a u -- a u ) text before the first comma, blanks trimmed.
\ A counted DO loop is not used here: I left the index on the stack and
\ the following fetch treated that index as an address.
: HX-A64-CUT  ( a u -- a u )
   DUP 0= IF  EXIT  THEN
   0
   BEGIN
      2DUP >
   WHILE
      2 PICK OVER + C@ 44 = IF
         NIP HX-A64-RTRIM EXIT
      THEN
      1+
   REPEAT
   DROP HX-A64-RTRIM ;

\ ( a u ca cu -- a' u' true | a u false ) true when the line starts with ca cu
: HX-TAKES  ( a u ca cu -- a' u' true | a u false )
   DUP >R
   2 PICK R@ < IF  R> DROP 2DROP FALSE EXIT  THEN
   3 PICK R@  3 PICK R@  COMPARE IF
      R> DROP 2DROP FALSE EXIT
   THEN
   2DROP
   R> /STRING TRUE ;

\ ( a u ca cu na nu -- a u false | true )
: HX-A64-TRY  ( a u ca cu na nu -- a u false | true )
   2>R
   2OVER 2OVER HX-TAKES IF
      2DROP 2DROP 2DROP
      2R> HX-EMIT TRUE
   ELSE
      2DROP 2DROP
      2R> 2DROP FALSE
   THEN ;

: HX-NAME-SET  ( c-addr u -- )
   63 MIN
   DUP HX-NAME C!
   HX-NAME 1+ SWAP CMOVE ;

CREATE HX-A64-NB  8 ALLOT

: HX-A64-EMIT2  ( c1 c2 -- )
   SWAP HX-A64-NB C!
   HX-A64-NB 1+ C!
   HX-A64-NB 2 HX-NAME-SET
   HX-NAME COUNT HX-EMIT ;

\ ( a u ca cu c1 c2 -- a u false | true )
: HX-A64-TRY2  ( a u ca cu c1 c2 -- a u false | true )
   2>R
   2OVER 2OVER HX-TAKES IF
      2DROP 2DROP 2DROP
      2R> HX-A64-EMIT2 TRUE
   ELSE
      2DROP 2DROP
      2R> 2DROP FALSE
   THEN ;

\ ( a u -- flag ) plain BOOT_WORD name, help, flags, code, end
: HX-A64-BOOT  ( a u -- flag )
   S" BOOT_WORD" HX-TAKES 0= IF  2DROP FALSE EXIT  THEN
   DUP 0= IF  2DROP FALSE EXIT  THEN
   OVER C@ BL <> IF  2DROP FALSE EXIT  THEN
   HX-SKIP-BL
   HX-A64-CUT
   DUP 0= IF  2DROP FALSE EXIT  THEN
   DUP 63 > IF  2DROP FALSE EXIT  THEN
   HX-EMIT TRUE ;

: HX-TRY-ARM64  ( a u -- flag )
   HX-SKIP-BL
   DUP 0= IF  2DROP FALSE EXIT  THEN
   OVER C@ [CHAR] ; = IF  2DROP FALSE EXIT  THEN
   S" BOOT_WORD_TIME_DATE" S" TIME&DATE" HX-A64-TRY IF  EXIT  THEN
   S" BOOT_WORD_CCOMMA" S" C," HX-A64-TRY IF  EXIT  THEN
   S" BOOT_WORD_COMMA" S" ," HX-A64-TRY IF  EXIT  THEN
   S" BOOT_WORD_BSLASH" S" \" HX-A64-TRY IF  EXIT  THEN
   S" BOOT_WORD_BS_S" S" \S" HX-A64-TRY IF  EXIT  THEN
   S" BOOT_WORD_SEMI" S" ;" HX-A64-TRY IF  EXIT  THEN
   S" BOOT_WORD_DOTQ" [CHAR] . [CHAR] " HX-A64-TRY2 IF  EXIT  THEN
   S" BOOT_WORD_CQUOTE" [CHAR] C [CHAR] " HX-A64-TRY2 IF  EXIT  THEN
   S" BOOT_WORD_SQUOTE" [CHAR] S [CHAR] " HX-A64-TRY2 IF  EXIT  THEN
   [CHAR] S HX-A64-NB C!
   [CHAR] \ HX-A64-NB 1+ C!
   [CHAR] " HX-A64-NB 2 + C!
   S" BOOT_WORD_SESCAPE" HX-A64-NB 3 HX-A64-TRY IF  EXIT  THEN
   [CHAR] ( HX-A64-NB C!
   [CHAR] S HX-A64-NB 1+ C!
   [CHAR] " HX-A64-NB 2 + C!
   [CHAR] ) HX-A64-NB 3 + C!
   S" BOOT_WORD_SLIT" HX-A64-NB 4 HX-A64-TRY IF  EXIT  THEN
   [CHAR] ( HX-A64-NB C!
   [CHAR] C HX-A64-NB 1+ C!
   [CHAR] " HX-A64-NB 2 + C!
   [CHAR] ) HX-A64-NB 3 + C!
   S" BOOT_WORD_CSTR" HX-A64-NB 4 HX-A64-TRY IF  EXIT  THEN
   HX-A64-BOOT ;

: HX-SCAN-ARM64-FILE  ( c-addr u -- )
   2DUP HX-PATH PLACE
   2DUP R/O OPEN-FILE IF
      DROP
      MIN-HYPER-NOISE @ 0= IF  ." HX: skip " TYPE CR  ELSE  2DROP  THEN
      EXIT
   THEN
   >R 2DROP
   HX-EMIT-AT
   0 TO HX-LINE#
   BEGIN
      HX-LINE 500 R@ READ-LINE
      IF  DROP DROP R> CLOSE-FILE DROP EXIT  THEN
      0= IF  DROP R> CLOSE-FILE DROP EXIT  THEN
      HX-LINE# 1+ TO HX-LINE#
      HX-LINE SWAP HX-TRY-ARM64 DROP
   AGAIN ;

: HX-SCAN-ARM64  ( -- )
   S" Library/Sources/arm64/prims.asm"     HX-SCAN-ARM64-FILE
   S" Library/Sources/arm64/prims_k1.asm"  HX-SCAN-ARM64-FILE
   S" Library/Sources/arm64/prims_k2.asm"  HX-SCAN-ARM64-FILE
   S" Library/Sources/arm64/prims_k3.asm"  HX-SCAN-ARM64-FILE
   S" Library/Sources/arm64/prims_dbg.asm" HX-SCAN-ARM64-FILE
   S" Library/Sources/arm64/dict.asm"      HX-SCAN-ARM64-FILE ;
