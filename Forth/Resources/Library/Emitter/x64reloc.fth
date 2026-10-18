\ x64reloc.fth — relocate a translated x64 image. Public domain.
\ The host prims are ml64, not ARM64. Intra-span branches stay valid
\ because the copy keeps the same distances. RIP-relative references
\ to the register file and to host BSS are retargeted into this image.
\ The runner places data immediately after the code, and the code is
\ padded to 4096 bytes so those distances survive the load.

8192 CONSTANT #X64-FIX
CREATE X64-FD  #X64-FIX CELLS ALLOT
CREATE X64-FK  #X64-FIX CELLS ALLOT
CREATE X64-FA  #X64-FIX CELLS ALLOT
CREATE X64-FT  #X64-FIX CELLS ALLOT
VARIABLE X64-FN

128 CONSTANT #X64-SPAN
CREATE X64-SH  #X64-SPAN CELLS ALLOT
CREATE X64-SNW #X64-SPAN CELLS ALLOT
CREATE X64-SU  #X64-SPAN CELLS ALLOT
VARIABLE X64-NS

VARIABLE X64-REG0
VARIABLE X64-0B
VARIABLE X64-CODELEN
VARIABLE X64-REGOFF
VARIABLE X64-AT

: X64-RESET ( -- )
  0 X64-FN !  0 X64-NS !  0 X64-REG0 !  0 X64-0B ! ;

: X64-LD32 ( addr -- u )
  >R
  R@ C@
  R@ 1+ C@ 8 LSHIFT OR
  R@ 2 + C@ 16 LSHIFT OR
  R> 3 + C@ 24 LSHIFT OR ;

: X64-SD32 ( u -- n )
  DUP $80000000 AND IF  $FFFFFFFF00000000 OR THEN ;

: X64-ST32 ( n addr -- )
  OVER $FF AND OVER C!
  OVER $FF00 AND 8 RSHIFT OVER 1+ C!
  OVER $FF0000 AND 16 RSHIFT OVER 2 + C!
  SWAP $FF000000 AND 24 RSHIFT SWAP 3 + C! ;

: X64-PREFIX? ( b -- flag )
  DUP $40 $50 WITHIN IF  DROP TRUE EXIT  THEN
  DUP $66 = OVER $F2 = OR OVER $F3 = OR
  OVER $2E = OR OVER $3E = OR OVER $26 = OR
  OVER $36 = OR OVER $64 = OR OVER $65 = OR
  SWAP $67 = OR ;

: X64-LEN {: a | p op op2 rexw modrm mod rm -- len :}
  a TO p  0 TO rexw
  BEGIN
    p C@ X64-PREFIX?
  WHILE
    p C@ $40 $50 WITHIN IF
      p C@ $8 AND IF  1 TO rexw  THEN
    THEN
    p 1+ TO p
  REPEAT
  p C@ TO op
  p 1+ TO p
  op $0F = IF
    p C@ TO op2
    p 1+ TO p
    op2 $80 $90 WITHIN IF  p 4 + a - EXIT  THEN
    $100 op2 + TO op
  THEN
  op $E8 = op $E9 = OR IF  p 4 + a - EXIT  THEN
  op $EB = op $70 $80 WITHIN OR IF  p 1+ a - EXIT  THEN
  op $04 = op $0C = OR op $14 = OR op $1C = OR op $24 = OR
  op $2C = OR op $34 = OR op $3C = OR op $A8 = OR IF
    p 1+ a - EXIT
  THEN
  op $05 = op $0D = OR op $15 = OR op $1D = OR op $25 = OR
  op $2D = OR op $35 = OR op $3D = OR op $A9 = OR IF
    p 4 + a - EXIT
  THEN
  op $98 = op $99 = OR op $90 $98 WITHIN OR
  op $F8 $FE WITHIN OR IF
    p a - EXIT
  THEN
  op $50 $60 WITHIN IF  p a - EXIT  THEN
  op $B8 $C0 WITHIN IF
    rexw IF  p 8 +  ELSE  p 4 +  THEN a - EXIT
  THEN
  p C@ TO modrm
  p 1+ TO p
  modrm 6 RSHIFT TO mod
  modrm $7 AND TO rm
  mod 3 <> rm 4 = AND IF
    p C@ TO op2
    p 1+ TO p
    mod 0= op2 $7 AND 5 = AND IF  p 4 + TO p  THEN
  THEN
  mod 0= rm 5 = AND IF  p 4 + TO p
  ELSE mod 1 = IF  p 1+ TO p
  ELSE mod 2 = IF  p 4 + TO p
  THEN THEN THEN
  op $83 = op $80 = OR op $C0 = OR op $C1 = OR op $C6 = OR
  op $6B = OR op $1BA = OR op $1AC = OR op $1AD = OR IF
    p 1+ TO p
  THEN
  op $C7 = op $81 = OR op $69 = OR IF  p 4 + TO p  THEN
  op $F7 = IF
    modrm 3 RSHIFT $7 AND DUP 0= SWAP 1 = OR IF  p 4 + TO p  THEN
  THEN
  op $F6 = IF
    modrm 3 RSHIFT $7 AND DUP 0= SWAP 1 = OR IF  p 1+ TO p  THEN
  THEN
  p a - ;

\ Bytes after a rip disp32. The next-instruction RIP includes them.
\ cmp byte [rip],imm is the signed-branch test; missing this tail
\ makes the N flag compare land in arm_x30.
: X64-TAIL {: a op | p reg -- n :}
  op $80 = op $83 = OR op $C0 = OR op $C1 = OR op $C6 = OR
  op $6B = OR op $1BA = OR op $1AC = OR op $1AD = OR IF
    1 EXIT
  THEN
  op $81 = op $C7 = OR op $69 = OR IF  4 EXIT  THEN
  op $F6 = op $F7 = OR 0= IF  0 EXIT  THEN
  a TO p
  BEGIN p C@ X64-PREFIX? WHILE  p 1+ TO p  REPEAT
  p 1+ C@ 3 RSHIFT 7 AND TO reg
  reg 2 U< 0= IF  0 EXIT  THEN
  op $F6 = IF  1  ELSE  4  THEN ;

\ ( addr -- target kind op )  kind 0 = not relative, 1 = rip mem, 2 = rel32, 3 = rel8
: X64-REL {: a | p op op2 disp tgt kind -- target kind op :}
  a TO p
  BEGIN p C@ X64-PREFIX? WHILE  p 1+ TO p  REPEAT
  p C@ TO op
  p 1+ TO p
  op $0F = IF
    p C@ TO op2
    p 1+ TO p
    op2 $80 $90 WITHIN IF
      p X64-LD32 X64-SD32 p 4 + + TO tgt
      tgt 2 $100 op2 + EXIT
    THEN
    $100 op2 + TO op
  THEN
  op $E8 = op $E9 = OR IF
    p X64-LD32 X64-SD32 p 4 + + TO tgt
    tgt 2 op EXIT
  THEN
  op $EB = op $70 $80 WITHIN OR IF
    p C@ DUP $80 AND IF  $FFFFFFFFFFFFFF00 OR THEN
    p 1+ + TO tgt
    tgt 3 op EXIT
  THEN
  op $B8 $C0 WITHIN IF  0 0 op EXIT  THEN
  op $50 $60 WITHIN IF  0 0 op EXIT  THEN
  op $90 $98 WITHIN op $98 = OR op $99 = OR
  op $F8 $FE WITHIN OR IF  0 0 op EXIT  THEN
  op $04 = op $0C = OR op $14 = OR op $1C = OR op $24 = OR
  op $2C = OR op $34 = OR op $3C = OR op $A8 = OR
  op $05 = OR op $0D = OR op $15 = OR op $1D = OR op $25 = OR
  op $2D = OR op $35 = OR op $3D = OR op $A9 = OR IF
    0 0 op EXIT
  THEN
  \ rip-relative modrm: mod 0, rm 5, and not a SIB opcode form
  p C@ TO op2
  op2 6 RSHIFT 0= op2 $7 AND 5 = AND IF
    p 1+ X64-LD32 X64-SD32 p 1+ 4 + +
    a op X64-TAIL + TO tgt
    tgt 1 op EXIT
  THEN
  0 0 op ;

: X64-REG-BASE ( -- addr )
  X64-REG0 @ ?DUP IF  EXIT  THEN
  ['] LOCAL-INIT PRIM-SPAN DROP
  DUP X64-REL
  DROP 1 <> IF
    ." x64: LOCAL-INIT does not start with a rip load" CR ABORT
  THEN
  160 - DUP X64-REG0 ! ;

: X64-FIX-ADD ( disp-addr kind arg tail -- )
  X64-FN @ #X64-FIX U< 0= IF
    ." x64: too many fixups" CR ABORT
  THEN
  X64-FN @ CELLS X64-FT + !
  X64-FN @ CELLS X64-FA + !
  X64-FN @ CELLS X64-FK + !
  X64-FN @ CELLS X64-FD + !
  1 X64-FN +! ;

: X64-SPAN-ADD ( host new u -- )
  X64-NS @ #X64-SPAN U< 0= IF  ." x64: too many spans" CR ABORT  THEN
  X64-NS @ CELLS X64-SU + !
  X64-NS @ CELLS X64-SNW + !
  X64-NS @ CELLS X64-SH + !
  1 X64-NS +! ;

: X64-SPAN-FIND ( tgt -- new|0 )
  {: tgt | i host u -- :}
  0 TO i
  BEGIN i X64-NS @ < WHILE
    i CELLS X64-SH + @ TO host
    i CELLS X64-SU + @ TO u
    tgt host host u + WITHIN IF
      i CELLS X64-SNW + @ tgt host - + EXIT
    THEN
    i 1+ TO i
  REPEAT
  0 ;

: X64-INDEX ( addr u c-addr n -- off|-1 )
  {: addr u s n | i -- :}
  0 TO i
  BEGIN i n + u <= WHILE
    addr i + n s n COMPARE 0= IF  i EXIT  THEN
    i 1+ TO i
  REPEAT
  -1 ;

: X64-WALK-U ( host u -- u2 )
  {: host u | i code bu patch off -- :}
  0 TO i
  BEGIN i SA-BLOCK-N @ < WHILE
    i CELLS SA-BLOCK-HOST + @ TO code
    i CELLS SA-BLOCK-U + @ TO bu
    host code = u bu = AND IF
      i CELLS SA-BLOCK-PATCH + @ TO patch
      patch ['] SA-FILES-PATCH-POOL = IF  u 40 - EXIT  THEN
      patch ['] SA-FLOAT-PATCH-POOL = IF  u 32 - EXIT  THEN
      patch ['] SA-PRINT-PATCH-POOL = IF
        host u S" -9223372036854775808" X64-INDEX TO off
        off 0< 0= IF  off EXIT  THEN
      THEN
    THEN
    i 1+ TO i
  REPEAT
  u ;

: X64-PATCH-REL8 ( disp-addr new-tgt -- )
  {: da tgt | disp -- :}
  tgt da 1+ - TO disp
  disp -128 < disp 127 > OR IF
    ." x64: rel8 out of range " disp . CR ABORT
  THEN
  disp $FF AND da C! ;

: X64-PATCH-CODE ( disp-addr new-tgt -- )
  {: da tgt | disp -- :}
  tgt da 4 + - TO disp
  disp X64-SD32 disp <> IF
    ." x64: branch out of range" CR ABORT
  THEN
  disp da X64-ST32 ;

: X64-END-C, ( b -- )
  TGT-END @ TGT-LIMIT @ 1- U> IF  ." x64: veneer overflow" CR ABORT  THEN
  TGT-END @ C!
  1 TGT-END +! ;

: X64-VENEER ( npc slot call? -- )
  DROP
  {: npc slot | ven disp -- :}
  TGT-END-ALIGN8
  TGT-END @ TO ven
  $48 X64-END-C,  $B8 X64-END-C,
  slot HOST-RELOC-ADD
  HOST-CALL-MAGIC slot OR VEN-,
  \ The image CALL already pushed the return address. A second
  \ CALL here enters the host with RSP 0 mod 16 and faults in the GUI.
  $FF X64-END-C,  $E0 X64-END-C,
  ven npc 5 + - TO disp
  disp npc 1+ X64-ST32 ;

DEFER X64-RELOC-RANGE ( host new u -- )

: X64-BLOCK-NEW ( tgt -- new-tgt|0 )
  {: tgt | code u new patch -- :}
  tgt SA-BLOCK-OF TO u TO code
  code 0= IF  0 EXIT  THEN
  code SA-HELP-FIND ?DUP IF
    tgt code - + EXIT
  THEN
  code u SA-HELP-COPY TO new
  code new u X64-SPAN-ADD
  code new u X64-RELOC-RANGE
  code SA-BLOCK-PATCH-OF TO patch
  patch IF  new u patch EXECUTE  THEN
  new tgt code - + ;

: X64-DISP-AT {: a | p op -- da :}
  a TO p
  BEGIN p C@ X64-PREFIX? WHILE  p 1+ TO p  REPEAT
  p C@ TO op
  p 1+ TO p
  op $0F = IF
    p C@ $80 $90 WITHIN IF  p 1+ EXIT  THEN
    p 1+ TO p
  THEN
  op $E8 = op $E9 = OR IF  p EXIT  THEN
  op $EB = op $70 $80 WITHIN OR IF  p EXIT  THEN
  p 1+ ;

: X64-FIX-OUT {: npc tgt kind op | code u new -- :}
  kind 1 = IF
    tgt X64-REG-BASE DUP 248 + WITHIN IF
      npc X64-DISP-AT 1 tgt X64-REG-BASE - 8 / npc op X64-TAIL X64-FIX-ADD EXIT
    THEN
    tgt X64-REG-BASE 248 + DUP 4 + WITHIN IF
      npc X64-DISP-AT 2 tgt X64-REG-BASE 248 + - npc op X64-TAIL X64-FIX-ADD EXIT
    THEN
    tgt X64-SPAN-FIND ?DUP IF
      npc X64-DISP-AT SWAP X64-PATCH-CODE EXIT
    THEN
    tgt SA-BSS-FIND ?DUP IF
      npc X64-DISP-AT 3 ROT TGT-DATA-ORG @ - npc op X64-TAIL X64-FIX-ADD EXIT
    THEN
    op $8D = IF
      npc X64-DISP-AT 3 tgt SA-BSS-ENSURE TGT-DATA-ORG @ - npc op X64-TAIL X64-FIX-ADD EXIT
    THEN
    ." x64: rip target " tgt U. ." op " op U. CR ABORT
  THEN
  kind 3 = IF
    ." x64: short branch leaves the span -> " tgt U. CR ABORT
  THEN
  tgt X64-SPAN-FIND ?DUP IF
    npc X64-DISP-AT SWAP X64-PATCH-CODE EXIT
  THEN
  tgt X64-BLOCK-NEW ?DUP IF
    npc X64-DISP-AT SWAP X64-PATCH-CODE EXIT
  THEN
  tgt HOST-SLOT-OF DUP 0< 0= IF
    npc SWAP op $E8 = X64-VENEER EXIT
  THEN
  DROP
  tgt EMM-SPAN-OF TO u TO code
  code IF
    code SA-HELP-FIND ?DUP IF
      tgt code - + TO new
    ELSE
      code u SA-HELP-COPY TO new
      code new u X64-SPAN-ADD
      code new u X64-RELOC-RANGE
      new tgt code - + TO new
    THEN
    npc X64-DISP-AT new X64-PATCH-CODE EXIT
  THEN
  kind 2 = op $E9 = AND IF
    \ Host jump with no image copy, usually DOCOL's empty-body exit.
    \ Send it to the copied NEXT instead of falling into the next bytes.
    npc X64-DISP-AT
    ['] (NEXT) MAP-FIND 8 +
    X64-PATCH-CODE
    EXIT
  THEN
  kind 2 = op $100 $190 WITHIN AND IF
    0 npc X64-DISP-AT X64-ST32
    EXIT
  THEN
  ." x64: branch target " tgt U. ." op " op U. CR ABORT ;

: (X64-RELOC-RANGE) {: host new u | off wu len tgt kind op da -- :}
  host u X64-WALK-U TO wu
  0 TO off
  BEGIN off wu < WHILE
    host off + X64-LEN TO len
    len 0= off len + wu U> OR IF
      off wu < IF  ." x64: truncated insn" CR ABORT  THEN
      wu TO off
    ELSE
      host off + X64-REL TO op TO kind TO tgt
      kind IF
        tgt host host wu + WITHIN 0= IF
          tgt host host u + 32 + WITHIN IF
            new tgt host - +
            new off + X64-DISP-AT SWAP
            kind 3 = IF  X64-PATCH-REL8  ELSE  X64-PATCH-CODE  THEN
          ELSE
            new off + tgt kind op X64-FIX-OUT
          THEN
        THEN
      THEN
      off len + TO off
    THEN
  REPEAT ;

' (X64-RELOC-RANGE) IS X64-RELOC-RANGE

: (X64-RELOC-PRIM) {: xt | code u new -- :}
  xt COLON-WORD? IF  EXIT  THEN
  xt DATA-WORD? IF  EXIT  THEN
  xt 0BRANCH-ADDR = IF  EXIT  THEN
  ?EMIT-STANDALONE IF
    xt SA-GLOBAL-PRIM? IF  EXIT  THEN
  THEN
  xt MAP-FIND DUP 0= IF  DROP EXIT  THEN
  8 + TO new
  xt PRIM-SPAN TO u TO code
  code new u X64-SPAN-ADD
  code new u X64-RELOC-RANGE ;

' (X64-RELOC-PRIM) IS X64-RELOC-PRIM

: (X64-HOST-PRIM-VA) {: xt | code u off len tgt kind op -- va :}
  xt PRIM-SPAN TO u TO code
  0 TO off
  BEGIN off u < WHILE
    code off + X64-LEN TO len
    len 0= IF  0 EXIT  THEN
    code off + X64-REL TO op TO kind TO tgt
    kind 2 = tgt code code u + WITHIN 0= AND IF  tgt EXIT  THEN
    off len + TO off
  REPEAT
  0 ;

' (X64-HOST-PRIM-VA) IS X64-HOST-PRIM-VA

: X64-TAKE-LEAS {: code u limit sizes | off n len tgt kind op -- :}
  0 TO off  0 TO n
  BEGIN off u < n limit < AND WHILE
    code off + X64-LEN TO len
    code off + X64-REL TO op TO kind TO tgt
    kind 1 = op $8D = AND IF
      tgt sizes n CELLS + @ SA-BSS-ENSURE-SZ DROP
      n 1+ TO n
    THEN
    off len + TO off
  REPEAT
  n limit < IF
    ." x64: lea discover n=" n . ." want " limit . CR ABORT
  THEN ;

CREATE X64-LOC-SZ  /SA-LOC-DEPTH , /SA-LOC-FRAMES , /SA-LOC-AUX , /SA-LOC-AUX ,

: (X64-LOCALS) ( -- )
  0 X64-REG0 !
  X64-REG-BASE DROP
  ['] LOCAL-INIT PRIM-SPAN
  4 X64-LOC-SZ X64-TAKE-LEAS
  ." x64 locals sized" CR ;

' (X64-LOCALS) IS X64-LOCALS-DISCOVER

: (X64-EXCEPT) {: | code u off n len tgt kind op da -- :}
  ['] CATCH PRIM-SPAN TO u TO code
  0 TO off  0 TO n
  BEGIN off u < WHILE
    code off + X64-LEN TO len
    code off + X64-REL TO op TO kind TO tgt
    kind 1 = op $8D = AND IF
      tgt SA-BSS-ENSURE TO da
      \ The next instruction stores the address into arm_x19 for the IP cell.
      code off + len + X64-REL TO op TO kind TO tgt
      kind 1 = tgt X64-REG-BASE 152 + = AND IF
        da TGT-DATA-ORG @ - 
        \ remember the host cell and its data stand-in
        code off + X64-REL DROP DROP
        SA-XC !
        da SA-DC !
        1 SA-IP19 !
      THEN
      n 1+ TO n
    THEN
    off len + TO off
  REPEAT
  n 5 < IF
    ." x64: CATCH lea discover n=" n . CR ABORT
  THEN
  SA-DC @ 0= IF
    ." x64: catch_ok_cell not found" CR ABORT
  THEN
  ." x64 catch leas n=" n . ." cfa-ok " SA-DC @ U. CR ;

' (X64-EXCEPT) IS X64-EXCEPT-DISCOVER

: (X64-JMP) ( target -- )
  $E9 TGT-C,
  TGT-HERE 4 + -
  TGT-W, ;

' (X64-JMP) IS X64-JMP,

: (X64-0BRANCH) ( -- )
  TGT-HERE X64-0B ! ;

' (X64-0BRANCH) IS X64-0BRANCH

: X64-DOCOL-IP8 ( -- )
  ['] (DOCOL) MAP-FIND DUP 0= IF  DROP EXIT  THEN
  {: a | n -- :}
  a 8 + TO a
  ['] (DOCOL) PRIM-SPAN NIP TO n
  BEGIN n 4 U< 0= WHILE
    a C@ $48 = a 1+ C@ $83 = AND a 2 + C@ $C0 = AND a 3 + C@ $10 = AND IF
      $08 a 3 + C!  EXIT
    THEN
    a 1+ TO a
    n 1- TO n
  REPEAT ;

: X64-PAD-CODE ( -- )
  TGT-END @ TGT-ORG @ -
  4095 + 4096 / 4096 *
  TGT-ORG @ +
  DUP TGT-LIMIT @ U> IF  ." x64: code pad overflow" CR ABORT  THEN
  TGT-END @
  BEGIN 2DUP U< WHILE  0 OVER C!  1+  REPEAT
  DROP TGT-END ! ;

: X64-ALLOT-REGS ( -- )
  TGT-DATA @ 0= IF  ." x64: no data segment" CR ABORT  THEN
  TGT-DATA-DP @ 7 + -8 AND
  DUP 256 + TGT-DATA-LIMIT @ U> IF
    ." x64: no room for the register file" CR ABORT
  THEN
  DUP TGT-DATA-ORG @ - X64-REGOFF !
  DUP 256 0 FILL
  256 + TGT-DATA-DP !
  256 TGT-DATA-BYTES +! ;

VARIABLE X64-I
VARIABLE X64-K
VARIABLE X64-A
VARIABLE X64-D

: X64-APPLY ( -- )
  TGT-SIZE X64-CODELEN !
  0 X64-I !
  BEGIN X64-I @ X64-FN @ < WHILE
    X64-I @ CELLS X64-FK + @ X64-K !
    X64-I @ CELLS X64-FA + @ X64-A !
    X64-I @ CELLS X64-FD + @ X64-D !
    X64-K @ 1 = IF
      X64-CODELEN @ X64-REGOFF @ + X64-A @ 8 * +
    ELSE X64-K @ 2 = IF
      X64-CODELEN @ X64-REGOFF @ + 248 + X64-A @ +
    ELSE
      X64-CODELEN @ X64-A @ +
    THEN THEN
    X64-D @ TGT-ORG @ - 4 +
    X64-I @ CELLS X64-FT + @ +
    -
    X64-D @ X64-ST32
    1 X64-I +!
  REPEAT ;

: XB ( b -- )  X64-AT @ C!  1 X64-AT +! ;
: X64-DTO ( off -- )
  X64-AT @ TGT-ORG @ - 4 + -
  X64-AT @ X64-ST32
  4 X64-AT +! ;
: X64-LDX ( index -- )
  $48 XB $8B XB $05 XB
  X64-CODELEN @ X64-REGOFF @ + SWAP 8 * + X64-DTO ;
: X64-STX ( index -- )
  $48 XB $89 XB $05 XB
  X64-CODELEN @ X64-REGOFF @ + SWAP 8 * + X64-DTO ;
: X64-JMP-NEXT ( -- )
  $E9 XB
  ['] (NEXT) MAP-FIND 8 + TGT-ORG @ - X64-DTO ;

: X64-WRITE-0B ( -- )
  X64-0B @ 0= IF  EXIT  THEN
  X64-0B @ X64-AT !
  20 X64-LDX
  0 X64-STX
  $4C XB $8B XB $15 XB
  X64-CODELEN @ X64-REGOFF @ + 176 + X64-DTO
  $49 XB $8B XB $02 XB
  20 X64-STX
  22 X64-LDX
  $48 XB $83 XB $C0 XB $08 XB
  22 X64-STX
  0 X64-LDX
  $48 XB $83 XB $F8 XB $00 XB
  $0F XB $85 XB
  X64-AT @ >R
  0 X64-AT @ X64-ST32
  4 X64-AT +!
  19 X64-LDX
  $48 XB $89 XB $C1 XB
  $48 XB $8B XB $01 XB
  $48 XB $03 XB $C1 XB
  19 X64-STX
  X64-JMP-NEXT
  R@ TGT-ORG @ - 4 +
  X64-AT @ TGT-ORG @ - SWAP -
  R> X64-ST32
  19 X64-LDX
  $48 XB $83 XB $C0 XB $08 XB
  19 X64-STX
  X64-JMP-NEXT
  X64-AT @ X64-0B @ - 0BRANCH-ADDR PRIM-SPAN NIP U> IF
    ." x64: 0BRANCH body does not fit" CR ABORT
  THEN ;

: (X64-FINISH) ( -- )
  X64-DOCOL-IP8
  X64-PAD-CODE
  X64-ALLOT-REGS
  X64-APPLY
  X64-WRITE-0B
  ." x64 reloc fixups " X64-FN @ . ." code " TGT-SIZE . CR ;

' (X64-FINISH) IS X64-FINISH

\ Install a reset on each build. TGT-RELOC calls SA-BSS-RESET already.
' X64-RESET IS X64-BUILD-RESET
