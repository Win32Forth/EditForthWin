\ SYNONYM's body leaves the old name in SOURCE. Eat that token.
' SYNONYM ALIAS (OLD-SYNONYM)
: SYNONYM (OLD-SYNONYM) PARSE-NAME 2DROP ;

\ SUBSTITUTE helpers live in SYSVOC, so this suffix keeps its own table.
\ Names match either case. The source is copied aside before the scan so a
\ destination that overlaps it cannot eat the pattern.
32 CONSTANT (SX-MAX)
CREATE (SX-NAMES) 32 32 * ALLOT
CREATE (SX-TEXTS) 32 256 * ALLOT
CREATE (SX-NBUF) 64 ALLOT
CREATE (SX-SRC) 256 ALLOT
VARIABLE (SX-CNT) 0 (SX-CNT) !
VARIABLE (SX-I)
VARIABLE (SX-DEST) VARIABLE (SX-MLEN) VARIABLE (SX-LEN)
VARIABLE (SX-N) VARIABLE (SX-ERR)

: (SX-NAME) ( i -- c-addr ) 32 * (SX-NAMES) + ;
: (SX-TEXT) ( i -- c-addr ) 256 * (SX-TEXTS) + ;
: (SX-FOLD) ( c -- c ) DUP 64 > OVER 91 < AND IF 32 + THEN ;
: (SX-CEQ) ( c1 u1 c2 u2 -- flag )
  DUP 3 PICK <> IF 2DROP 2DROP FALSE EXIT THEN
  DROP SWAP 0 ?DO
    OVER I + C@ (SX-FOLD) OVER I + C@ (SX-FOLD) <>
    IF 2DROP UNLOOP FALSE EXIT THEN
  LOOP 2DROP TRUE ;
: (SX-FIND) ( c-addr u -- i true | false )
  (SX-CNT) @ 0 ?DO
    2DUP I (SX-NAME) COUNT (SX-CEQ) IF 2DROP I TRUE UNLOOP EXIT THEN
  LOOP 2DROP FALSE ;
: (SX-ADD) ( c -- )
  (SX-LEN) @ (SX-MLEN) @ < IF
    (SX-DEST) @ (SX-LEN) @ + C! 1 (SX-LEN) +!
  ELSE DROP -1 (SX-ERR) ! THEN ;
: (SX-ADDS) ( c-addr u -- )
  BEGIN DUP WHILE OVER C@ (SX-ADD) 1 /STRING REPEAT 2DROP ;
: (SX-LOOK) ( c-addr u -- )
  2DUP (SX-FIND) IF NIP NIP (SX-TEXT) COUNT (SX-ADDS) 1 (SX-N) +!
  ELSE 37 (SX-ADD) (SX-ADDS) 37 (SX-ADD) THEN ;
: (SX-HIT) ( c1 u1 c2 u2 -- flag )
  DUP 0= IF 2DROP 2DROP FALSE EXIT THEN
  2 PICK 0= IF 2DROP 2DROP FALSE EXIT THEN
  >R >R OVER + R@ <= IF DROP R> DROP R> DROP FALSE EXIT THEN
  R> R> + <= 0= ;
: REPLACES ( c-addr1 u1 c-addr2 u2 -- )
  2DUP (SX-FIND) IF NIP NIP (SX-TEXT) PLACE EXIT THEN
  (SX-CNT) @ (SX-MAX) >= IF 2DROP 2DROP EXIT THEN
  DUP 31 > IF 2DROP 2DROP EXIT THEN
  2 PICK 255 > IF 2DROP 2DROP EXIT THEN
  (SX-CNT) @ >R R@ (SX-NAME) PLACE R@ (SX-TEXT) PLACE R> 1+ (SX-CNT) ! ;
: SUBSTITUTE ( c-addr1 u1 c-addr2 u2 -- c-addr2 u3 n )
  (SX-MLEN) ! (SX-DEST) !
  DUP 256 > IF
    2DUP (SX-DEST) @ (SX-MLEN) @ (SX-HIT) IF
      2DROP (SX-DEST) @ 0 -1 EXIT
    THEN
  ELSE 2DUP (SX-SRC) SWAP MOVE NIP (SX-SRC) SWAP THEN
  0 (SX-LEN) ! 0 (SX-N) ! 0 (SX-ERR) !
  BEGIN DUP 0> WHILE
    OVER C@ 37 <> IF OVER C@ (SX-ADD) 1 /STRING
    ELSE DUP 1 > IF OVER 1+ C@ 37 = IF 37 (SX-ADD) 2 /STRING
      ELSE 0 (SX-I) ! BEGIN 1 (SX-I) +!
        DUP (SX-I) @ > 0= IF (SX-ADDS) 0 0 TRUE
        ELSE OVER (SX-I) @ + C@ 37 = IF
          OVER 1+ (SX-I) @ 1- (SX-NBUF) PLACE (SX-NBUF) COUNT (SX-LOOK)
          (SX-I) @ 1+ /STRING TRUE
        ELSE FALSE THEN THEN
      UNTIL THEN
    ELSE 37 (SX-ADD) 1 /STRING THEN THEN
  REPEAT 2DROP (SX-DEST) @ (SX-LEN) @ (SX-ERR) @ IF (SX-ERR) @ ELSE (SX-N) @ THEN ;
