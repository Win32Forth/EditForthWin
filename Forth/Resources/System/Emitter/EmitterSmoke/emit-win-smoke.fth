\ emit-win-smoke.fth — white window, hello 42, three color squares.
\ Depth 4 is a square list: color x y w h. Public domain.

ONLY FORTH DEFINITIONS DECIMAL
FROMLIB FLOAD Emitter/emitter.fth

ONLY FORTH DEFINITIONS
ALSO SYSVOC ALSO EMITTER ALSO GRAPHICS

CREATE MARKS 120 ALLOT

: LAY ( color x y w h n -- )
  40 * MARKS + >R
  R@ 32 + !
  R@ 24 + !
  R@ 16 + !
  R@ 8 + !
  R> !
;

: T-WIN ( -- )
  80 25 (APP-OPEN) DROP
  S" Emit Win" (APP-NAME)
  S" hello 42" (APP-BLIT)
  255 24 36 40 40 0 LAY
  65280 96 36 40 40 1 LAY
  16711680 168 36 40 40 2 LAY
  MARKS 120 4 (APP-CBLIT)
  (APP-KEY) DROP
  (APP-CLOSE)
;

: (WIN-EMIT) ( -- )
  ['] T-WIN EMIT-APP-XT
;

(WIN-EMIT)
CR ." --- emit-win-smoke built ---" CR
