\ app-win.fth — Windows packer for EMIT-APP and EMIT-WINDOW-APP.
\ Loaded after app.fth. Public domain.
\
\ The Mac packer (app.fth (EMIT-PACK)) stays on app-build.sh and NAME.app.
\ This file does not call that script. When C:\Windows\System32\cmd.exe
\ exists, EMIT-OS-MKDIR and EMIT-OS-PACK are retargeted here.
\
\ Both EMIT-APP and EMIT-WINDOW-APP use those hooks, so a window emit
\ writes the same Windows bundle. The bundle is a folder:
\   <outdir>/<NAME>/<NAME>.img   64EMIT02 image
\   <outdir>/<NAME>/app.img      the copy the exe loads
\ emit-win.exe (runner\emit-win.c) is the window host. This packer copies
\ it to <outdir>/<NAME>/<NAME>.exe next to those images, plus host.fix so
\ the runner can rebind sa_win_putchar and sa_win_file_op. SAVE-IMAGE
\ writes <outdir>/<NAME>.img first; this packer moves that file into the
\ bundle so it does not sit beside the source.
\ The image still runs in this process via LOAD-IMAGE TGT-RUN-LOADED.
\ Absolute host pointers (sa_win_putchar, sa_win_file_op, key_fn) stay
\ valid only in the process that built the image.
\
\ Leaves FORTH as CURRENT with EMITTER on the search order.

ONLY FORTH ALSO SYSVOC ALSO EMITTER DEFINITIONS
DECIMAL

CREATE EMIT-WIN-IMG   /EMIT-PB ALLOT
CREATE EMIT-WIN-EXE   /EMIT-PB ALLOT
CREATE EMIT-COPYBUF   4096 ALLOT

\ True on this Windows tree. False on a Mac, so the Mac packer stays armed.
: EMIT-WINDOWS?  ( -- flag )
  S" C:/Windows/System32/cmd.exe" FILE-STATUS NIP 0= IF
    TRUE EXIT
  THEN
  S" C:\Windows\System32\cmd.exe" FILE-STATUS NIP 0= ;

\ cmd.exe /c strips one leading quote and one trailing quote.
\ The extra quotes leave: mkdir "path"
: (EMIT-MKDIR-WIN)  ( c-addr u -- )
  {: a u -- :}
  u 0= IF  EXIT  THEN
  u 1 = IF  a C@ [CHAR] . = IF  EXIT  THEN THEN
  a u FILE-STATUS NIP 0= IF  EXIT  THEN
  EMIT-CMDBUF (EMIT-S0)
  [CHAR] " EMIT-CMDBUF (EMIT-CH+)
  S" mkdir " EMIT-CMDBUF (EMIT-S+)
  [CHAR] " EMIT-CMDBUF (EMIT-CH+)
  a u EMIT-CMDBUF (EMIT-S+)
  [CHAR] " EMIT-CMDBUF (EMIT-CH+)
  [CHAR] " EMIT-CMDBUF (EMIT-CH+)
  EMIT-CMDBUF COUNT SYSTEM IF
    ." EMIT-APP: mkdir failed: " a u TYPE CR ABORT
  THEN ;

: (EMIT-COPY-FILE)  ( sa su da du -- )
  {: sa su da du | sf df n -- :}
  sa su R/O BIN OPEN-FILE IF
    DROP ." EMIT-APP: cannot read " sa su TYPE CR ABORT
  THEN
  TO sf
  da du W/O BIN CREATE-FILE IF
    DROP sf CLOSE-FILE DROP
    ." EMIT-APP: cannot write " da du TYPE CR ABORT
  THEN
  TO df
  BEGIN
    EMIT-COPYBUF 4096 sf READ-FILE IF
      DROP
      sf CLOSE-FILE DROP  df CLOSE-FILE DROP
      ." EMIT-APP: copy read failed" CR ABORT
    THEN
    TO n
    n 0= IF
      sf CLOSE-FILE DROP  df CLOSE-FILE DROP  EXIT
    THEN
    EMIT-COPYBUF n df WRITE-FILE IF
      sf CLOSE-FILE DROP  df CLOSE-FILE DROP
      ." EMIT-APP: copy write failed" CR ABORT
    THEN
  0 UNTIL ;

\ Append an unsigned decimal number onto a counted string.
: (EMIT-APPEND-U)  ( u dest -- )
  {: u dest | p n dig -- :}
  PAD 24 + TO p
  0 TO n
  BEGIN
    u 10 /MOD TO u TO dig
    dig [CHAR] 0 + p C!
    p 1- TO p
    n 1+ TO n
    u 0=
  UNTIL
  p 1+ n dest (EMIT-S+) ;

\ host.fix lists code offsets of the Windows function DCQs.
: (EMIT-HOST-FIX)  ( -- )
  {: | fid -- :}
  SA-WIN-PUT @ 0= SA-WIN-FILE @ 0= AND IF  EXIT  THEN
  TGT-ORG @ 0= IF  EXIT  THEN
  EMIT-CMDBUF (EMIT-S0)
  SA-WIN-PUT @ IF
    S" putchar " EMIT-CMDBUF (EMIT-S+)
    SA-WIN-PUT @ TGT-ORG @ - EMIT-CMDBUF (EMIT-APPEND-U)
    10 EMIT-CMDBUF (EMIT-CH+)
  THEN
  SA-WIN-FILE @ IF
    S" file " EMIT-CMDBUF (EMIT-S+)
    SA-WIN-FILE @ TGT-ORG @ - EMIT-CMDBUF (EMIT-APPEND-U)
    10 EMIT-CMDBUF (EMIT-CH+)
  THEN
  EMIT-WIN-IMG (EMIT-S0)
  EMIT-APPBUF COUNT EMIT-WIN-IMG (EMIT-S+)
  S" /host.fix" EMIT-WIN-IMG (EMIT-S+)
  EMIT-WIN-IMG COUNT W/O BIN CREATE-FILE IF
    DROP ." EMIT-APP: cannot write host.fix" CR ABORT
  THEN
  TO fid
  EMIT-CMDBUF COUNT fid WRITE-FILE IF
    fid CLOSE-FILE DROP
    ." EMIT-APP: host.fix write failed" CR ABORT
  THEN
  fid CLOSE-FILE DROP ;

\ Outdir is already in EMIT-TMP. SAVE-IMAGE already wrote EMIT-IMGBUF.
\ Replace the Mac .app path in EMIT-APPBUF with the bundle folder.
\ Copy emit-win.exe in beside app.img.
: (EMIT-PACK-WIN)  ( -- )
  EMIT-TMP COUNT  EMIT-NAMEBUF COUNT  0 0  EMIT-APPBUF  (EMIT-JOIN)
  EMIT-APPBUF COUNT (EMIT-MKDIR-WIN)
  \ SAVE-IMAGE wrote <outdir>/<NAME>.img. The image belongs in the bundle.
  EMIT-WIN-IMG (EMIT-S0)
  EMIT-APPBUF COUNT EMIT-WIN-IMG (EMIT-S+)
  S" /" EMIT-WIN-IMG (EMIT-S+)
  EMIT-NAMEBUF COUNT EMIT-WIN-IMG (EMIT-S+)
  S" .img" EMIT-WIN-IMG (EMIT-S+)
  EMIT-IMGBUF COUNT  EMIT-WIN-IMG COUNT  (EMIT-COPY-FILE)
  EMIT-IMGBUF COUNT DELETE-FILE IF
    ." EMIT-APP: cannot remove " EMIT-IMGBUF COUNT TYPE CR ABORT
  THEN
  EMIT-WIN-IMG COUNT EMIT-IMGBUF PLACE
  EMIT-WIN-IMG (EMIT-S0)
  EMIT-APPBUF COUNT EMIT-WIN-IMG (EMIT-S+)
  S" /app.img" EMIT-WIN-IMG (EMIT-S+)
  EMIT-IMGBUF COUNT  EMIT-WIN-IMG COUNT  (EMIT-COPY-FILE)
  LIBRARY-PATH DUP 0= IF
    2DROP ." EMIT-APP: LIBRARY-PATH empty" CR ABORT
  THEN
  EMIT-WIN-EXE (EMIT-S0)
  EMIT-WIN-EXE (EMIT-S+)
  X64-HOST? IF
    S" /Emitter/runner/emit-win-x64.exe"
  ELSE
    S" /Emitter/runner/emit-win.exe"
  THEN
  EMIT-WIN-EXE (EMIT-S+)
  EMIT-WIN-EXE COUNT FILE-STATUS NIP IF
    ." EMIT-APP: emit-win.exe missing: " EMIT-WIN-EXE COUNT TYPE CR ABORT
  THEN
  EMIT-WIN-IMG (EMIT-S0)
  EMIT-APPBUF COUNT EMIT-WIN-IMG (EMIT-S+)
  S" /" EMIT-WIN-IMG (EMIT-S+)
  EMIT-NAMEBUF COUNT EMIT-WIN-IMG (EMIT-S+)
  S" .exe" EMIT-WIN-IMG (EMIT-S+)
  EMIT-WIN-EXE COUNT EMIT-WIN-IMG COUNT (EMIT-COPY-FILE)
  CR ." EMIT-APP: built " EMIT-APPBUF COUNT TYPE CR
  ."   image: " EMIT-IMGBUF COUNT TYPE CR
  ."   exe: " EMIT-WIN-IMG COUNT TYPE CR
  (EMIT-HOST-FIX) ;

\ Colon word: interpret IF/THEN does not skip.
: EMIT-WIN-ARM  ( -- )
  EMIT-WINDOWS? 0= IF  EXIT  THEN
  ['] (EMIT-MKDIR-WIN) IS EMIT-OS-MKDIR
  ['] (EMIT-PACK-WIN) IS EMIT-OS-PACK
  .( emit-win: Windows packer armed) CR ;

EMIT-WIN-ARM

ONLY FORTH DEFINITIONS
ALSO SYSVOC ALSO EMITTER
