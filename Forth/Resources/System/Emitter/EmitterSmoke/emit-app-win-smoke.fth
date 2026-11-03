\ emit-app-win-smoke.fth — Windows EMIT-APP saves a bundle, then reloads it.
\ Does not call app-build.sh. Public domain.
\
\   FROMLIB FLOAD Emitter/EmitterSmoke/emit-app-win-smoke.fth

ONLY FORTH DEFINITIONS DECIMAL
FROMLIB FLOAD Emitter/emitter.fth

ONLY FORTH ALSO SYSVOC ALSO EMITTER DEFINITIONS

: T-DOT  ( -- )  42 . ;

: (WIN-EMIT)  ( -- )
  ['] T-DOT EMIT-APP-XT ;

(WIN-EMIT)

: (WIN-RELOAD)  ( -- )
  CR ." --- emit-app-win reload ---" CR
  TGT-CLOSE
  EMIT-IMGBUF COUNT LOAD-IMAGE
  TGT-RUN-LOADED
  CR ." --- emit-app-win done ---" CR ;

(WIN-RELOAD)
