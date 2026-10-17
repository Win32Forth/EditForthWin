\ hx-x64.fth — index ml64 output of the armasm64 BOOT_WORD macro.
\
\ Each word is a BWSTR block then the code label:
\   nm_XDUP:
\       DB "DUP", 0
\   ...
\   XDUP:
\ The indexed line is the code label. Names that armasm stored as
\ numeric bytes (semicolon, quote, backslash) are rebuilt from the DB line.
\
\ Loaded from hyper-index.fth into HYPER-VOC.

ONLY FORTH ALSO HYPER-VOC DEFINITIONS

0 VALUE HX64-MODE          \ 0 idle, 1 next DB is the name, 2 wait for code label
0 VALUE HX64-N
0 VALUE HX64-DIGS
CREATE HX64-LAB  64 ALLOT

: HX64-LAB!  ( c-addr u -- )
   63 MIN
   DUP HX64-LAB C!
   HX64-LAB 1+ SWAP CMOVE ;

: HX64-ADD  ( c -- flag )
   HX-NAME C@ 63 >= IF  DROP FALSE EXIT  THEN
   HX-NAME COUNT + C!
   HX-NAME C@ 1+ HX-NAME C!
   TRUE ;

: HX64-HEX?  ( c -- n true | false )
   DUP [CHAR] 0 [CHAR] 9 1+ WITHIN IF  [CHAR] 0 - TRUE EXIT  THEN
   DUP [CHAR] A [CHAR] F 1+ WITHIN IF  [CHAR] A - 10 + TRUE EXIT  THEN
   DUP [CHAR] a [CHAR] f 1+ WITHIN IF  [CHAR] a - 10 + TRUE EXIT  THEN
   DROP FALSE ;

\ Digit run is hex when the source writes 22h, and decimal 0 is still 0.
: HX64-NUMBER  ( a u -- a' u' n true | false )
   HX-SKIP-BL
   DUP 0= IF  2DROP FALSE EXIT  THEN
   0 TO HX64-N
   0 TO HX64-DIGS
   BEGIN
      DUP 0= IF
         HX64-DIGS 0= IF  2DROP FALSE EXIT  THEN
         HX64-N TRUE EXIT
      THEN
      OVER C@ HX64-HEX? IF
         HX64-N 16 * + TO HX64-N
         HX64-DIGS 1+ TO HX64-DIGS
         HX-SKIP1
      ELSE
         HX64-DIGS 0= IF  2DROP FALSE EXIT  THEN
         OVER C@ DUP [CHAR] h = SWAP [CHAR] H = OR IF  HX-SKIP1  THEN
         HX64-N TRUE EXIT
      THEN
   AGAIN ;

\ ( a u -- a' u' flag ) a u sits on the opening quote
: HX64-QUOTED  ( a u -- a' u' flag )
   HX-SKIP1
   BEGIN  DUP WHILE
      OVER C@ [CHAR] " = IF
         HX-SKIP1
         DUP IF  OVER C@ [CHAR] " = IF
            [CHAR] " HX64-ADD DROP
            HX-SKIP1
         ELSE  TRUE EXIT  THEN
         ELSE  TRUE EXIT  THEN
      ELSE
         OVER C@ HX64-ADD 0= IF  2DROP FALSE EXIT  THEN
         HX-SKIP1
      THEN
   REPEAT
   2DROP FALSE ;

\ ( a u -- flag ) consume the line. True when a name was stored.
: HX64-PARSE-DB  ( a u -- flag )
   HX-SKIP-BL
   DUP 3 < IF  2DROP FALSE EXIT  THEN
   OVER 2 S" DB" COMPARE IF  2DROP FALSE EXIT  THEN
   2 /STRING
   DUP 0= IF  2DROP FALSE EXIT  THEN
   OVER C@ BL <> IF  2DROP FALSE EXIT  THEN
   0 HX-NAME C!
   BEGIN
      HX-SKIP-BL
      DUP IF  OVER C@ [CHAR] , = IF  HX-SKIP1 HX-SKIP-BL  THEN  THEN
      DUP 0= IF  2DROP HX-NAME C@ 0<> EXIT  THEN
      OVER C@ [CHAR] " = IF
         HX64-QUOTED 0= IF  FALSE EXIT  THEN
      ELSE
         HX64-NUMBER 0= IF  FALSE EXIT  THEN
         DUP 0= IF  DROP 2DROP HX-NAME C@ 0<> EXIT  THEN
         HX64-ADD 0= IF  2DROP FALSE EXIT  THEN
      THEN
   AGAIN ;

\ ( a u -- a n true | false ) ident immediately followed by ':'
: HX64-LABEL  ( a u -- a n true | false )
   HX-SKIP-BL
   DUP 0= IF  2DROP FALSE EXIT  THEN
   OVER C@ HX-LABCHAR? 0= IF  2DROP FALSE EXIT  THEN
   0
   BEGIN
      DUP 2 PICK < IF
         2 PICK OVER + C@ HX-LABCHAR? IF
            1+ FALSE
         ELSE  TRUE  THEN
      ELSE  TRUE  THEN
   UNTIL
   DUP 0= IF  DROP 2DROP FALSE EXIT  THEN
   2 PICK OVER + C@ [CHAR] : <> IF  DROP 2DROP FALSE EXIT  THEN
   >R DROP R> TRUE ;

: HX64-IS-NM  ( a u -- a' u' true | false )
   DUP 3 < IF  2DROP FALSE EXIT  THEN
   OVER 3 S" nm_" COMPARE IF  2DROP FALSE EXIT  THEN
   3 /STRING TRUE ;

: HX64-LINE  ( a u -- )
   HX-SKIP-BL
   DUP 0= IF  2DROP EXIT  THEN
   OVER C@ [CHAR] ; = IF  2DROP EXIT  THEN
   2DUP HX64-LABEL IF
      2SWAP 2DROP
      2DUP HX64-IS-NM IF
         2SWAP 2DROP HX64-LAB!
         1 TO HX64-MODE
      ELSE
         HX64-MODE 2 = IF
            HX64-LAB COUNT COMPARE 0= IF
               HX-NAME C@ IF  HX-NAME COUNT HX-EMIT  THEN
               0 TO HX64-MODE
            THEN
         ELSE  2DROP  THEN
      THEN
   ELSE
      HX64-MODE 1 = IF
         HX64-PARSE-DB IF  2 TO HX64-MODE  THEN
      ELSE  2DROP  THEN
   THEN ;

: HX-SCAN-X64-FILE  ( c-addr u -- )
   0 TO HX64-MODE
   0 HX-NAME C!
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
      HX-LINE SWAP HX64-LINE
   AGAIN ;

: HX-SCAN-X64  ( -- )
   S" Library/Sources/x64/prims.asm"     HX-SCAN-X64-FILE
   S" Library/Sources/x64/prims_k1.asm"  HX-SCAN-X64-FILE
   S" Library/Sources/x64/prims_k2.asm"  HX-SCAN-X64-FILE
   S" Library/Sources/x64/prims_k3.asm"  HX-SCAN-X64-FILE
   S" Library/Sources/x64/prims_dbg.asm" HX-SCAN-X64-FILE
   S" Library/Sources/x64/dict.asm"      HX-SCAN-X64-FILE ;
