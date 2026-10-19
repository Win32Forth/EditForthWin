\ target.fth — emitter step 2
\ Requires reach.fth
\ Public domain.

\ Loaded under EMITTER DEFINITIONS (see emitter.fth).
DECIMAL

DEFER TGT-RELOC
DEFER HOST-BIND

: TGT-RELOC-NONE  ( -- )  ;
' TGT-RELOC-NONE  IS TGT-RELOC

: HOST-BIND-NONE  ( -- )  ;
' HOST-BIND-NONE  IS HOST-BIND

VARIABLE TGT
VARIABLE TGT-ORG
VARIABLE TGT-DP
VARIABLE TGT-LIMIT
VARIABLE TGT-END
VARIABLE TGT-ALLOC    \ length given to ALLOCATE-EXEC / FREE-EXEC

: TGT-HERE  TGT-DP @ ;

: TGT-ALLOT  ( n -- )
  TGT-DP @ + DUP TGT-LIMIT @ U> IF
    ." tgt: overflow" CR ABORT
  THEN TGT-DP ! ;

: TGT,   TGT-HERE !  8 TGT-ALLOT ;
: TGT-C, TGT-HERE C!  1 TGT-ALLOT ;
: TGT-ALIGN  TGT-HERE 7 + -8 AND TGT-DP ! ;

\ 32-bit store (ARM insn). Must not use cell ! — that writes 8 bytes and
\ clobbers the next prim's CFA when stitching a trailing B.
: TGT-W!  ( u32 addr -- )
  2DUP C!  SWAP 8 RSHIFT SWAP
  2DUP 1+ C!  SWAP 8 RSHIFT SWAP
  2DUP 2 + C!  SWAP 8 RSHIFT SWAP
  3 + C! ;
: TGT-W,  ( u32 -- )
  TGT-HERE TGT-W!  4 TGT-ALLOT ;

\ x64 images are relocated by Emitter/x64reloc.fth. These stay no-ops
\ until that file installs them. On ARM64, X64-HOST? is false.
DEFER X64-JMP,     ( target -- )
DEFER X64-0BRANCH  ( -- )
DEFER X64-BUILD-RESET ( -- )
: (X64-JMP-NOP)    ( target -- )  DROP ;
: (X64-0BRANCH-NOP) ( -- )  ;
' (X64-JMP-NOP) IS X64-JMP,
' (X64-0BRANCH-NOP) IS X64-0BRANCH
' (X64-0BRANCH-NOP) IS X64-BUILD-RESET

\ x64reloc.fth records the payload and writes the body at finish.
DEFER X64-NOTE-THROW ( -- )
DEFER X64-NOTE-DSP ( xt -- )
: (X64-NOTE-THROW-NOP) ( -- )
  ." x64: THROW writer missing" CR ABORT ;
: (X64-NOTE-DSP-NOP) ( xt -- )
  DROP ." x64: DSP writer missing" CR ABORT ;
' (X64-NOTE-THROW-NOP) IS X64-NOTE-THROW
' (X64-NOTE-DSP-NOP) IS X64-NOTE-DSP

VARIABLE TGT-DATA         \ RW ALLOCATE base (stand-alone data segment)
VARIABLE TGT-DATA-ORG
VARIABLE TGT-DATA-DP
VARIABLE TGT-DATA-LIMIT
VARIABLE TGT-DATA-ALLOC

: TGT-DATA-CLOSE  ( -- )
  TGT-DATA @ IF  TGT-DATA @ FREE DROP  THEN
  0 TGT-DATA !  0 TGT-DATA-ORG !  0 TGT-DATA-DP !
  0 TGT-DATA-LIMIT !  0 TGT-DATA-ALLOC ! ;

: TGT-CLOSE  ( -- )
  TGT @ IF
    TGT @ TGT-ALLOC @ FREE-EXEC DROP
  THEN
  0 TGT !  0 TGT-ORG !  0 TGT-DP !  0 TGT-LIMIT !  0 TGT-END !
  0 TGT-ALLOC !
  TGT-DATA-CLOSE ;

: TGT-DATA-OPEN  ( u -- )
  TGT-DATA-CLOSE
  DUP TGT-DATA-ALLOC !
  DUP ALLOCATE IF  DROP ." data ALLOCATE failed" CR ABORT  THEN
  DUP TGT-DATA !
  DUP TGT-DATA-ORG !
  DUP TGT-DATA-DP !
  + TGT-DATA-LIMIT ! ;

: TGT-OPEN  ( u -- )
  TGT-CLOSE
  DUP TGT-ALLOC !
  DUP ALLOCATE-EXEC IF  DROP ." ALLOCATE-EXEC failed" CR ABORT  THEN
  DUP TGT !
  DUP TGT-ORG !
  DUP TGT-DP !
  + TGT-LIMIT ! ;

CREATE TGT-OLD REACH-MAX CELLS ALLOT
CREATE TGT-NEW REACH-MAX CELLS ALLOT
VARIABLE TGT-MAPN

: MAP-FIND  {: old | i -- new :}
  0 TO i
  BEGIN  i TGT-MAPN @ <  WHILE
    i CELLS TGT-OLD + @  old = IF
      i CELLS TGT-NEW + @ EXIT
    THEN
    i 1+ TO i
  REPEAT
  0 ;

: .MAP  {: | i -- :}
  CR ." map " TGT-MAPN @ . CR
  0 TO i
  BEGIN  i TGT-MAPN @ <  WHILE
    i . SPACE
    i CELLS TGT-OLD + @ DUP NAME>STRING TYPE SPACE U. SPACE
    i CELLS TGT-NEW + @ U. CR
    i 1+ TO i
  REPEAT ;

: MAP!  ( old new -- )
  TGT-MAPN @ CELLS TGT-NEW + !
  TGT-MAPN @ CELLS TGT-OLD + !
  1 TGT-MAPN +! ;

\ Smallest boot-code address strictly above addr, or 0.
\ Windows THROW's BOOT_WORD end field is 0, but the body is contiguous
\ in .text up to the next boot word (PARSE). That gap is the span.
: NEXT-CODE-AFTER  ( addr -- end|0 )
  {: addr | best row c -- :}
  0 TO best
  BOOT-WORD-TABLE BOOT-WORD-TABLE-END
  BEGIN  2DUP <  WHILE
    OVER @ TO row
    row BOOT-WORD-CODE TO c
    c addr U> IF
      best 0=  c best U<  OR IF  c TO best  THEN
    THEN
    SWAP CELL+ SWAP
  REPEAT
  2DROP best ;

\ Defined here so THROW-OPEN-SPAN can see it. Setters are below.
FALSE VALUE ?EMIT-STANDALONE

VARIABLE SA-THROW-SEEN
\ ( code -- code u )
\ ARM copies THROW through the next boot word (the quit branch is
\ turned into a no-op later). The x64 translation of that body jumps
\ through the host, so a stand-alone image only reserves a slot.
\ x64reloc.fth writes a register-file THROW into it at finish.
: THROW-OPEN-SPAN  ( code -- code u )
  DUP C@ $48 = IF
    ?EMIT-STANDALONE 0= IF
      ." prim: x64 THROW has no end label" CR ABORT
    THEN
    512
    SA-THROW-SEEN @ 0= IF
      ." x64-throw span " DUP . CR
      1 SA-THROW-SEEN !
    THEN
    EXIT
  THEN
  DUP NEXT-CODE-AFTER
  DUP 0= IF
    DROP ." prim: THROW has no following boot code" CR ABORT
  THEN
  OVER -
  DUP 64 U<  OVER 512 U>  OR IF
    ." prim: THROW open span " . ." out of range" CR ABORT
  THEN
  SA-THROW-SEEN @ 0= IF
    ." sa-throw span " DUP . CR
    1 SA-THROW-SEEN !
  THEN ;

: PRIM-SPAN  ( xt -- code u )
  \ Unknown / non-boot CODE must not be sliced (end=0 ⇒ garbage length).
  DUP >R CODE-BOUNDS
  DUP 0= IF
    \ Live kernel: BOOT_WORD THROW, ..., XTHROW, 0. Mac has XTHROW_END.
    \ ARM's first insn is CBZ (top byte $B4). x64 starts with REX.W ($48).
    \ X64-HOST? is defined later and itself calls PRIM-SPAN.
    R@ ['] THROW = IF
      OVER DUP C@ $48 = SWAP 3 + C@ $B4 = OR IF
        DROP R> DROP THROW-OPEN-SPAN EXIT
      THEN
    THEN
    DROP DROP
    ." prim: no CODE-BOUNDS for " R> NAME>STRING TYPE CR ABORT
  THEN
  R> DROP
  2DUP SWAP - NIP ;

\ Translated x64 prims begin with REX.W MOV (48 8B ...). ARM64 LOCAL-INIT does not.
: X64-HOST?  ( -- flag )
  ['] LOCAL-INIT PRIM-SPAN DROP C@ $48 = ;

\ CREATE/VALUE/CONSTANT/DOES>: default identity map (in-process TGT-RUN).
\ /EMIT-STANDALONE copies each data region into the target image (Phase 1).
: /EMIT-STANDALONE  ( -- )  TRUE  TO ?EMIT-STANDALONE ;
: /EMIT-HOSTDATA    ( -- )  FALSE TO ?EMIT-STANDALONE ;

\ EMIT-WINDOW-APP: remap FORTH console I/O xts → GRAPHICS at MAP-CELL time
\ so app sources (BI./PI./.) need not recompile under ALSO GRAPHICS.
\ EMIT-APP leaves this false (console / SA-PRINT → write(1)).
FALSE VALUE ?EMIT-WINDOW
: /EMIT-WINDOW   ( -- )  TRUE  TO ?EMIT-WINDOW ;
: /EMIT-CONSOLE  ( -- )  FALSE TO ?EMIT-WINDOW ;

\ Phase 2b: leave MAGIC|slot .quads unbound so SAVE-IMAGE can persist them.
\ Default false — TGT-BUILD still HOST-BINDs for interactive TGT-RUN.
FALSE VALUE ?EMIT-UNBOUND
: /EMIT-UNBOUND  ( -- )  TRUE  TO ?EMIT-UNBOUND ;
: /EMIT-BOUND    ( -- )  FALSE TO ?EMIT-UNBOUND ;

\ Installed by reloc.fth once GRAPHICS-WID exists (window I/O force-reach).
DEFER TGT-MARK-WINDOW-IO
: TGT-MARK-WINDOW-IO-NONE  ( -- )  ;
' TGT-MARK-WINDOW-IO-NONE IS TGT-MARK-WINDOW-IO

\ Installed by reloc.fth: FORTH EMIT/TYPE/… → GRAPHICS counterparts when
\ ?EMIT-WINDOW. Identity otherwise.
DEFER IO-REMAP  ( xt -- xt' )
: IO-REMAP-NONE  ( xt -- xt )  ;
' IO-REMAP-NONE IS IO-REMAP

VARIABLE TGT-DATA-BYTES

\ Phase 2b: absolute pointer cells in the image (ITC xts, CFAs).
\ Blind u64 walks corrupt ARM prims; SAVE-IMAGE persists this table instead.
\ 1024 was enough for GRAPHICS mini; tetra MAIN needs ~2k+ (ITC cells).
8192 CONSTANT #PTR-RELOC
CREATE PTR-RELOC-OFF  #PTR-RELOC CELLS ALLOT
CREATE PTR-RELOC-SPC  #PTR-RELOC ALLOT   \ 0=code 1=data
VARIABLE PTR-RELOC-N
: PTR-RELOC-CLEAR  ( -- )  0 PTR-RELOC-N ! ;

: PTR-RELOC-ADD  ( addr space -- )
  {: a sp -- :}
  PTR-RELOC-N @ #PTR-RELOC U< 0= IF
    ." too many ptr relocs n=" PTR-RELOC-N @ U. ." max=" #PTR-RELOC U. CR ABORT
  THEN
  a  PTR-RELOC-N @ CELLS PTR-RELOC-OFF + !
  sp PTR-RELOC-N @ PTR-RELOC-SPC + C!
  1 PTR-RELOC-N +! ;

: PTR,  ( x -- )  \ TGT, of an absolute pointer into the image
  TGT-HERE 0 PTR-RELOC-ADD
  TGT, ;

\ End of a data word = smallest HFA of any dictionary word above this CFA.
\ Covers CREATE…, and CREATE n ALLOT (FIGURE / NOTES): body runs until the
\ next header. CFA+24 fallback = does_ip + one cell (lone VALUE/CONSTANT).
\ Prefer a full wordlist scan so size does not depend on the next word being
\ reachable. FORTH-WORDLIST is latest_var and is not in WORDLISTS, so a
\ WORDLISTS-only walk never sees FORTH words. CLOCK's CREATE strings then
\ fell back to CFA+24 and the roman numerals were omitted.
\ TRAVERSE-WORDLIST uses the return stack, so the wid index stays here
\ on the data stack (?DO would share that stack and drop every HFA).
VARIABLE DE-XT
VARIABLE DE-BEST

: DE-VISIT  ( nt -- flag )
  DUP DE-XT @ <> IF
    HFA DUP DE-XT @ U> IF
      DE-BEST @ 0= IF  DE-BEST !
      ELSE  DUP DE-BEST @ U< IF  DE-BEST !  ELSE  DROP  THEN
      THEN
    ELSE  DROP
    THEN
  ELSE  DROP
  THEN
  TRUE ;

: DATA-END  ( xt -- addr )
  DE-XT !  0 DE-BEST !
  FORTH-WORDLIST ['] DE-VISIT SWAP TRAVERSE-WORDLIST
  WORDLISTS ( addr n )
  BEGIN DUP WHILE
    1-
    2DUP CELLS + @ ['] DE-VISIT SWAP TRAVERSE-WORDLIST
  REPEAT 2DROP
  DE-BEST @ DUP 0= IF  DROP DE-XT @ 24 +  THEN ;

: DATA-SPAN  ( xt -- addr u )
  DUP DATA-END  OVER - ;

: RESERVE-IMPORT  ( xt -- )
  ?EMIT-STANDALONE 0= IF  DUP MAP! EXIT  THEN
  {: xt | new u -- :}
  TGT-DATA-DP @ 7 + -8 AND DUP TGT-DATA-DP !  TO new
  xt DATA-SPAN NIP TO u
  u 0= IF
    ." data: empty span for " xt NAME>STRING TYPE CR ABORT
  THEN
  u 7 + -8 AND TO u
  new u + DUP TGT-DATA-LIMIT @ U> IF
    ." data: overflow" CR ABORT
  THEN
  TGT-DATA-DP !
  u TGT-DATA-BYTES +!
  xt new MAP! ;

: COLON-SPAN  ( xt -- addr u )
  \ Body addr and byte length (branch-aware; see COLON-END in reach.fth).
  DUP COLON-END  SWAP BODY  SWAP ;

\ Prim bodies that ADRP to 64Forth BSS/globals cannot be copied as raw ARM.
\ Under /EMIT-STANDALONE, carve them as DOVAR data in the RW segment instead.
: SA-GLOBAL-PRIM?  ( xt -- flag )
  DUP ['] PAD = IF  DROP TRUE EXIT  THEN
  ['] BASE = ;

: RESERVE-SA-GLOBAL  ( xt -- )
  {: xt | new u -- :}
  TGT-DATA-DP @ 7 + -8 AND DUP TGT-DATA-DP ! TO new
  \ DOVAR: CFA + does_ip + user PFA. PAD needs >=256 bytes at PFA for <#…#>.
  xt ['] PAD = IF  16 1024 +  ELSE  24  THEN TO u
  u 7 + -8 AND TO u
  new u + DUP TGT-DATA-LIMIT @ U> IF
    ." data: overflow (sa-global)" CR ABORT
  THEN
  TGT-DATA-DP !
  u TGT-DATA-BYTES +!
  xt new MAP! ;

: RESERVE-PRIM  {: xt | new u -- :}
  ?EMIT-STANDALONE IF
    xt SA-GLOBAL-PRIM? IF  xt RESERVE-SA-GLOBAL EXIT  THEN
  THEN
  TGT-ALIGN
  TGT-HERE TO new
  xt PRIM-SPAN NIP 7 + -8 AND 8 + TO u
  xt ['] (NEXT) <> IF  u 4 + TO u  THEN
  \ keep following CFA 8-aligned (stitch B is 4 bytes)
  u 7 + -8 AND TO u
  u TGT-ALLOT
  xt new MAP! ;

: RESERVE-COLON  {: xt | new u -- :}
  TGT-ALIGN
  TGT-HERE TO new
  xt COLON-SPAN NIP 8 + TO u
  u 7 + -8 AND TO u
  u TGT-ALLOT
  xt new MAP! ;
  
: COPY-BYTES  ( src u -- )
  0 ?DO DUP I + C@ TGT-C, LOOP DROP TGT-ALIGN ;

\ 0BRANCH: host prim ADRPs to data_stack SP0 and clamps DSP to that SP0.
\ TGT-RUN uses a separate RUN-DSP, so the host guard breaks UNTIL/#S loops
\ (forward IF can still appear to work). Emit a guard-free body for every
\ emit mode; STITCH still places a trailing B after the reserved host span.
: B-ABS,  ( target -- )
  TGT-HERE - 2 ARSHIFT
  $03FFFFFF AND $14000000 OR  TGT-W, ;

: WRITE-0BRANCH-SA  ( -- )
  $AA1403E0 TGT-W,                    \ MOV X0, X20
  $F84086D4 TGT-W,                    \ LDR X20, [X22], #8
  $B4000060 TGT-W,                    \ CBZ X0, +3
  $91002273 TGT-W,                    \ ADD X19, X19, #8
  ['] (NEXT) MAP-FIND 8 + B-ABS,
  $F9400260 TGT-W,                    \ LDR X0, [X19]
  $8B000273 TGT-W,                    \ ADD X19, X19, X0
  ['] (NEXT) MAP-FIND 8 + B-ABS,
  ;

\ DEPTH / SP0 / CLEARSTACK ADRP the host data_stack and add 4096.
\ A stand-alone image has no such stack. One RW cell holds this magic
\ until the runner stores the empty DSP (x22 at entry) over it.
\ emit-win.c and TGT-RUN both know SA-DSP0-MAGIC.
$C0DE0000000000D0 CONSTANT SA-DSP0-MAGIC
VARIABLE SA-DSP0-CELL
VARIABLE SA-DSP0-LIT

: SA-DSP-PRIM?  ( xt -- flag )
  DUP ['] DEPTH = IF  DROP TRUE EXIT  THEN
  DUP ['] SP0 = IF  DROP TRUE EXIT  THEN
  DUP ['] CLEARSTACK = IF  DROP TRUE EXIT  THEN
  \ EXECUTE ADRPs data_stack+4096 to see an empty stack. The stand-in
  \ is always below the real DSP, so the empty path keeps TOS = 0 and
  \ the xt's arguments stay buried (APP-NAME then sees length 0).
  ['] EXECUTE = ;

\ Bodies live in reloc.fth (they emit LDR-lit veneers). Installed there.
DEFER WRITE-DEPTH-SA       ( -- )
DEFER WRITE-SP0-SA         ( -- )
DEFER WRITE-CLEARSTACK-SA  ( -- )
DEFER WRITE-EXECUTE-SA     ( -- )
: (WRITE-DSP-MISSING)  ( -- )
  ." sa-dsp: reloc not loaded" CR ABORT ;
' (WRITE-DSP-MISSING) IS WRITE-DEPTH-SA
' (WRITE-DSP-MISSING) IS WRITE-SP0-SA
' (WRITE-DSP-MISSING) IS WRITE-CLEARSTACK-SA
' (WRITE-DSP-MISSING) IS WRITE-EXECUTE-SA

: WRITE-SA-GLOBAL  ( xt -- )
  {: xt | new -- :}
  xt NAME>STRING TYPE SPACE ." sa-global" CR
  xt MAP-FIND DUP 0= IF  ." no map" CR ABORT  THEN  TO new
  \ DOVAR layout: CFA+0 engine, +8 does_ip, +16 user PFA (see forth.s).
  \ Use engine payload addr (map+8), not CFA @ — (DOVAR) may not be written yet.
  ['] (DOVAR) MAP-FIND DUP 0= IF  ." no (DOVAR)" CR ABORT  THEN
  8 + new !
  new 1 PTR-RELOC-ADD
  0 new 8 + !                         \ does_ip
  xt ['] BASE = IF  10 new 16 + !  THEN \ DECIMAL at user PFA
  ;

: WRITE-PRIM  ( xt -- )
  ?EMIT-STANDALONE IF
    DUP SA-GLOBAL-PRIM? IF  WRITE-SA-GLOBAL EXIT  THEN
  THEN
  DUP NAME>STRING TYPE SPACE ." prim" CR
  DUP MAP-FIND DUP 0= IF ." no map" CR ABORT THEN
  DUP TGT-DP !                 \ ( xt new )
  DUP 8 + OVER !               \ CFA cell → payload; ( xt new )
  DUP 0 PTR-RELOC-ADD          \ record CFA pointer cell
  DROP                         \ ( xt )
  8 TGT-ALLOT
  DUP 0BRANCH-ADDR = IF
    DROP
    X64-HOST? IF  X64-0BRANCH EXIT  THEN
    WRITE-0BRANCH-SA EXIT
  THEN
  \ Stand-alone x64: THROW has no end label, and the stack prims still
  \ name the host data stack. The bodies are filled in at X64-FINISH.
  ?EMIT-STANDALONE X64-HOST? AND IF
    DUP ['] THROW = IF  DROP X64-NOTE-THROW EXIT  THEN
    DUP SA-DSP-PRIM? IF  X64-NOTE-DSP EXIT  THEN
  THEN
  \ Stand-alone ARM: host DEPTH/SP0/CLEARSTACK ADRP data_stack.
  ?EMIT-STANDALONE X64-HOST? 0= AND IF
    DUP SA-DSP-PRIM? IF
      DUP ['] DEPTH = IF  DROP WRITE-DEPTH-SA EXIT  THEN
      DUP ['] SP0 = IF  DROP WRITE-SP0-SA EXIT  THEN
      DUP ['] EXECUTE = IF  DROP WRITE-EXECUTE-SA EXIT  THEN
      DROP WRITE-CLEARSTACK-SA EXIT
    THEN
  THEN
  PRIM-SPAN COPY-BYTES ;

\ --- DOES> fragments (stand-alone) ---------------------------------------
\ Host does_ip points at an ITC xt list ending in EXIT. Slice once per
\ unique host IP into the code image (appended at TGT-END) and retarget.

16 CONSTANT #DOES-FRAG
CREATE DOES-HOST  #DOES-FRAG CELLS ALLOT
CREATE DOES-NEW   #DOES-FRAG CELLS ALLOT
VARIABLE DOES-N
: DOES-CLEAR  ( -- )  0 DOES-N ! ;

: DOES-FIND  ( host-ip -- new|0 )
  {: hip | i -- :}
  0 TO i
  BEGIN  i DOES-N @ <  WHILE
    i CELLS DOES-HOST + @ hip = IF
      i CELLS DOES-NEW + @ EXIT
    THEN
    i 1+ TO i
  REPEAT
  0 ;

: MAP-CELL  ( old -- )
  IO-REMAP
  DUP MAP-FIND ?DUP IF  NIP PTR,  ELSE
    ." unmapped " NAME>STRING TYPE CR ABORT
  THEN ;

: DOES-EMIT  ( host-ip -- new )
  {: hip | new -- :}
  DOES-N @ #DOES-FRAG U< 0= IF
    ." does: too many fragments" CR ABORT
  THEN
  TGT-END @ 7 + -8 AND TGT-DP !
  TGT-HERE TO new
  hip
  BEGIN
    DUP @ MAP-CELL
    DUP @ ['] EXIT = IF
      DROP
      TGT-HERE TGT-END !
      hip DOES-N @ CELLS DOES-HOST + !
      new DOES-N @ CELLS DOES-NEW + !
      1 DOES-N +!
      new EXIT
    THEN
    8 +
  AGAIN ;

: DOES-SLICE  ( host-ip -- new )
  DUP DOES-FIND ?DUP IF  NIP EXIT  THEN
  DOES-EMIT ;

\ If addr falls inside a mapped DATA-WORD's host span, slide it to the
\ sliced copy (for LIT PFAs from TO, etc.).
: DATA-REBASE  ( addr -- addr' flag )
  {: a | i w new -- :}
  0 TO i
  BEGIN  i TGT-MAPN @ <  WHILE
    i CELLS TGT-OLD + @ TO w
    w DATA-WORD? IF
      a w U< 0= IF
        a w DATA-END U< IF
          w MAP-FIND DUP 0= IF  DROP a FALSE EXIT  THEN  TO new
          a w - new +  TRUE EXIT
        THEN
      THEN
    THEN
    i 1+ TO i
  REPEAT
  a FALSE ;

: LIT-PAYLOAD,  ( host-lit -- )
  \ LIT cells live in the code image (colon bodies).
  \ xt literals (CATCH / ['] / EMIT wrap) must become mapped CFAs —
  \ DATA-REBASE covers VALUE/VARIABLE PFAs from TO once those words are
  \ in the map (see LIT-PAYLOAD-MARK). Window builds remap FORTH→GRAPHICS.
  IO-REMAP
  DUP MAP-FIND ?DUP IF
    NIP
    TGT-HERE 0 PTR-RELOC-ADD
    TGT, EXIT
  THEN
  DATA-REBASE IF  TGT-HERE 0 PTR-RELOC-ADD  TGT, EXIT  THEN
  \ Stand-alone: leftover host VAs become `!`/`@` into IDE memory → SEGV.
  \ Do not treat sign-extended immediates (-1 TRUE, -2, …) as pointers —
  \ those are $FFFF… in the high bits, not canonical user VAs.
  ?EMIT-STANDALONE IF
    DUP $FFFF000000000000 AND 0= IF          \ not sign-extended neg
      DUP $100000000 U< 0= IF               \ above low 4GiB
        DUP $0000800000000000 U< IF         \ below 48-bit user VA hole
          ." LIT: unmapped host addr " DUP U. CR ABORT
        THEN
      THEN
    THEN
  THEN
  TGT, ;

\ After MOVE of a DODOES/DOCON import, retarget user-PFA cells that hold
\ mapped xts (CONSTANT / VALUE / DEFER / IS targets). Without this,
\ (DOODLE-XT) / (EMIT-GFX-KEY) keep a host CFA — EXECUTE SEGVs and the
\ window only flashes. Cells that are not mapped xts are left alone.
: IMPORT-RELOC-XT-CELLS  ( new u -- )
  {: new u | a end x n -- :}
  new 16 + TO a
  new u + TO end
  BEGIN  a 8 + end U> 0= WHILE    \ while cell [a,a+8) fits in span
    a @ IO-REMAP TO x
    x MAP-FIND ?DUP IF
      TO n
      n a !
      a 1 PTR-RELOC-ADD
    THEN
    a 8 + TO a
  REPEAT ;

\ DOVAR/DODOES user PFA (new+16): drop host heap / foreign pointers so
\ stand-alone does not FREE or dereference emit-session malloc addresses.
\ CONSTANT is CREATE , DOES> @ (DODOES), so its value cell is sanitized too.
\ Keep:
\   - integers below 4 GiB (DOCON / SCAN-DOCON cutoff): ED-CAP0, VED-CAP,
\     BI-BASE (1e9)
\   - sign-extended negatives (-1, -2, …) — same rule as LIT-PAYLOAD;
\     unsigned ">= 4GiB" would otherwise zero -1 CONSTANT / VALUE
\ Host malloc is a canonical user VA above 4 GiB (top bits clear).
\ Older $10000 / $100000 thresholds zeroed size CONSTANTs (empty Open,
\ BI!U UM/MOD with BI-BASE=0 → SEGV).
: SA-SANITIZE-DOVAR  ( new u -- )
  {: new u | a end v -- :}
  new 16 + TO a
  new u + TO end
  BEGIN  a 8 + end U> 0= WHILE
    a @ TO v
    v IF
      v $FFFF000000000000 AND IF  \ sign-extended immediate — keep
      ELSE
        v $100000000 U< 0= IF     \ keep small integers / buffer sizes
          v MAP-FIND ?DUP IF  DROP  \ keep mapped xt
          ELSE
            v DATA-REBASE IF  a !   \ slide into sliced data
            ELSE  DROP 0 a !  THEN  \ foreign (host heap, etc.) → 0
          THEN
        THEN
      THEN
    THEN
    a 8 + TO a
  REPEAT ;

\ Copy CFA..DATA-END into the RW data segment; retarget CFA to sliced
\ (DOVAR)/(DOCON)/(DODOES). DOES> does_ip is sliced into code (DOES-SLICE).
: WRITE-IMPORT  ( xt -- )
  ?EMIT-STANDALONE 0= IF  DROP EXIT  THEN
  {: xt | new u code -- :}
  xt NAME>STRING TYPE SPACE ." data" SPACE
  xt DATA-SPAN NIP DUP TO u . CR
  xt MAP-FIND DUP 0= IF  ." no map" CR ABORT  THEN  TO new
  xt new u MOVE
  \ Prefer sliced runtime CFA if already written; else host code addr
  \ (WRITE order writes prims before imports — see TGT-WRITE).
  xt DOVAR? IF  ['] (DOVAR)
  ELSE xt DOCON? IF  ['] (DOCON)
  ELSE  ['] (DODOES)  THEN THEN
  \ Payload at map+8 — engine CFA @ may still be 0 if not yet WRITE-PRIM'd.
  MAP-FIND DUP 0= IF  ." no engine map" CR ABORT  THEN
  8 + TO code
  code new !
  new 1 PTR-RELOC-ADD
  xt DOVAR? IF  new u SA-SANITIZE-DOVAR  THEN
  xt DOCON? IF
    \ CONSTANT of an xt must be reachable; leftover host CFA → EXECUTE SEGV.
    new 16 + @ IO-REMAP
    DUP $100000000 U< IF  DROP
    ELSE  MAP-FIND 0= IF
      ." DOCON: unmapped xt PFA in " xt NAME>STRING TYPE CR ABORT
    THEN THEN
    new u IMPORT-RELOC-XT-CELLS
  THEN
  xt DODOES? IF
    new 8 + @ DOES-SLICE
    new 8 + !
    new 8 + 1 PTR-RELOC-ADD
    \ VALUE/DEFER/CREATE payloads: zero host heap (e.g. G-BUF) before xt remap.
    \ IMPORT-RELOC alone leaves foreign pointers; stand-alone then skips
    \ G-ALLOC-BUF and SIGSEGVs — window flashes.
    new u SA-SANITIZE-DOVAR
    new u IMPORT-RELOC-XT-CELLS
  THEN ;

: WRITE-BODY  ( xt -- )
  \ Copy full colon body (past mid-colon EXIT from IF EXIT THEN).
  \ Stack walk: ( addr ) with end on return stack.
  COLON-SPAN OVER + >R              \ R: end  ( addr )
  BEGIN
    DUP R@ >= IF  DROP R> DROP EXIT  THEN
    DUP @                           \ addr xt
    DUP ['] EXIT = IF
      MAP-CELL 8 +                  \ mid or final EXIT
    ELSE DUP LIT-ADDR = IF
      MAP-CELL 8 + DUP @ LIT-PAYLOAD, 8 +
    ELSE DUP BR-OP? IF
      MAP-CELL 8 + DUP @ TGT, 8 +
    ELSE DUP SLIT-ADDR = IF
      MAP-CELL
      8 + DUP @ TGT,
      DUP 8 + OVER @ COPY-BYTES
      SLIT-SKIP
    ELSE
      MAP-CELL 8 +
    THEN THEN THEN THEN
  AGAIN ;

: WRITE-COLON  ( xt -- )
  DUP NAME>STRING TYPE SPACE ." colon" CR
  DUP MAP-FIND DUP 0= IF ." no map" CR ABORT THEN
  TGT-DP !
  ['] (DOCOL) MAP-FIND DUP 0= IF ." no DOCOL map" CR ABORT THEN
  @ PTR,
  WRITE-BODY ;

: TGT-RESERVE  {: | RI -- :}
  0 TO RI
  0 TGT-MAPN !
  ." reserve n=" REACH-N @ . CR
  BEGIN  RI REACH-N @ <  WHILE
    RI . SPACE
    RI CELLS REACH-XTS + @
    DUP NAME>STRING TYPE SPACE
    DUP COLON-WORD? IF  ." colon"  CR RESERVE-COLON
    ELSE DUP DATA-WORD? IF
      ?EMIT-STANDALONE IF ." data" ELSE ." import" THEN CR RESERVE-IMPORT
    ELSE                ." prim"   CR RESERVE-PRIM
    THEN THEN
    RI 1+ TO RI
  REPEAT
  ." maps=" TGT-MAPN @ . CR
  ?EMIT-STANDALONE IF  ." data-bytes " TGT-DATA-BYTES @ . CR  THEN
  TGT-HERE TGT-END ! ;

: TGT-WRITE  {: | RI -- :}
  \ 1) CODE prims first so DATA CFA patches can MAP-FIND (DOVAR)/…
  0 TO RI
  BEGIN  RI REACH-N @ <  WHILE
    RI CELLS REACH-XTS + @
    DUP COLON-WORD? IF  DROP
    ELSE DUP DATA-WORD? IF  DROP
    ELSE  WRITE-PRIM  THEN THEN
    RI 1+ TO RI
  REPEAT
  \ 2) DATA into RW segment
  0 TO RI
  BEGIN  RI REACH-N @ <  WHILE
    RI CELLS REACH-XTS + @
    DUP DATA-WORD? IF  WRITE-IMPORT  ELSE DROP THEN
    RI 1+ TO RI
  REPEAT
  \ 3) Colon bodies
  0 TO RI
  BEGIN  RI REACH-N @ <  WHILE
    RI CELLS REACH-XTS + @
    DUP COLON-WORD? IF  WRITE-COLON ELSE DROP THEN
    RI 1+ TO RI
  REPEAT ;

: TGT-SIZE  ( -- u )  TGT-END @ TGT-ORG @ - ;

\ --- step 3a: stitch ITC dispatch -----------------------------------------

: ARM-B,  ( target -- )
  \ emit 32-bit B from TGT-HERE to target (see TGT-W!, not cell !)
  TGT-HERE - 2 ARSHIFT
  $03FFFFFF AND $14000000 OR
  TGT-W, ;

: STITCH-NEXT  ( xt -- )
  DUP ['] (NEXT) = IF  DROP EXIT  THEN
  DUP COLON-WORD? IF  DROP EXIT  THEN
  DUP DATA-WORD? IF  DROP EXIT  THEN   \ host import — no copied body
  \ Stand-alone PAD/BASE are DOVAR in the data seg (no code to stitch).
  \ Hostdata still copies those prims — must stitch B (NEXT) or SIGILL.
  DUP SA-GLOBAL-PRIM? ?EMIT-STANDALONE AND IF  DROP EXIT  THEN
  DUP MAP-FIND 8 +                  \ payload
  SWAP PRIM-SPAN NIP +              \ addr just after copied bytes
  TGT-DP !
  ['] (NEXT) MAP-FIND 8 +           \ NEXT payload
  X64-HOST? IF  X64-JMP, EXIT  THEN
  ARM-B, ;

: TGT-STITCH  {: | i -- :}
  0 TO i
  BEGIN  i TGT-MAPN @ <  WHILE
    i CELLS TGT-OLD + @  STITCH-NEXT
    i 1+ TO i
  REPEAT ;

: TGT-PROTECT  ( -- )
  TGT-ORG @ TGT-SIZE 5 MPROTECT THROW
  TGT-ORG @ TGT-SIZE ICACHE-INVAL ;

\ ABORT → THROW with no outer interpreter in SA. Apps must CATCH.
\ Use 1 THROW (not ABORT) so a test harness can CATCH the refusal cleanly.
: TGT-REQUIRE-CATCH  ( -- )
  ['] ABORT MARKED? 0= IF  EXIT  THEN
  ['] CATCH MARKED? IF  EXIT  THEN
  ." emit: ABORT reachable but CATCH is not" CR
  ."   wrap the entry with CATCH (handle errors; never QUIT)" CR
  1 THROW ;

\ CATCH returns via (CATCH-OK) in SYSVOC; mark it when CATCH is in the graph.
: (CATCH-OK-XT)  ( -- xt )
  S" (CATCH-OK)" ['] SYSVOC 2 CELLS + SEARCH-WORDLIST
  0= IF  ." (CATCH-OK) missing from SYSVOC" CR 1 THROW  THEN ;

: TGT-MARK-CATCH-OK  ( -- )
  ['] CATCH MARKED? 0= IF  EXIT  THEN
  (CATCH-OK-XT) (MARK) ;

: TGT-BUILD  ( xt -- )
  X64-BUILD-RESET
  0 SA-DSP0-CELL !  0 SA-DSP0-LIT !  0 SA-THROW-SEEN !
  TGT-CLOSE
  0 TGT-DATA-BYTES !
  PTR-RELOC-CLEAR
  DOES-CLEAR
  REACH-FROM
  TGT-REQUIRE-CATCH
  TGT-MARK-CATCH-OK
  TGT-MARK-WINDOW-IO
  ['] (DOCOL) (MARK)
  ['] (NEXT)  (MARK)
  ['] EXIT    (MARK)
  ?EMIT-STANDALONE IF
    ['] (DOVAR)  (MARK)
    ['] (DOCON)  (MARK)
    ['] (DODOES) (MARK)
  THEN
  \ Window/TRUECOLOR apps pull G-PIX (~1 MiB) into the data segment.
  262144 TGT-OPEN
  ?EMIT-STANDALONE IF  2097152 TGT-DATA-OPEN  THEN
  \ Use U. — GRAPHICS on the search order shadows FORTH .
  ." opened " TGT-ORG @ U.  TGT-LIMIT @ U.  ."  cap " TGT-SIZE U. CR
  ?EMIT-WINDOW IF  ." window-io: FORTH EMIT/TYPE/CR/. /KEY → GRAPHICS" CR  THEN
  TGT-RESERVE
  ." reserved " TGT-SIZE U. CR
  TGT-WRITE
  TGT-STITCH
  TGT-RELOC
  \ Phase 2a: bind MAGIC|slot .quads while image is still RW (before R+X).
  \ /EMIT-UNBOUND (Phase 2b): skip bind so SAVE-IMAGE keeps MAGIC|slot;
  \ TGT-RUN binds later via HOST-BIND-IF-NEEDED.
  ?EMIT-UNBOUND 0= IF  HOST-BIND  THEN
  TGT-PROTECT
  ." written " TGT-SIZE U. CR
  ?EMIT-UNBOUND IF  ." unbound (MAGIC|slot)" CR  THEN
  ?EMIT-STANDALONE IF
    ." standalone data-bytes " TGT-DATA-BYTES @ U. CR
    ." data-seg " TGT-DATA-ORG @ U. TGT-DATA-DP @ U. CR
    ." ptr-relocs " PTR-RELOC-N @ U. CR
  THEN
  ;

: TGT-DUMP  ( -- )
  HEX
  TGT-ORG @
  BEGIN  DUP TGT-END @ U<  WHILE
    CR DUP U. SPACE  DUP @ U.
    8 +
  REPEAT DROP
  DECIMAL CR ;
  
