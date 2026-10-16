# Remaining assembly words

Compared on Oct 16, 2026. The Mac kernel (`EditForth/Forth/Kernel/forth.s`) has 401 boot words. The Windows ARM64 kernel has 361. Forty Mac names have no Windows header. Four Windows words are still stubs, and `FORGET` parses a name without removing it. `(LOCAL)` and trailing-dot doubles were fixed after this list was taken.

Punctuation names (`;` `,` `\` `\S` `S"` `(S")` `."` `S\"` `C"` `(C")` `C,` `TIME&DATE`) are present on both sides.

## Present, body does not do the work

| Word | What the body does |
| --- | --- |
| `(F-OP)` | Drops the opcode. Every `FLOATING` word (`F+`, `FDEPTH`, and the rest) goes through this. |
| `(LOCAL)` | Was a stub: while compiling it dropped the name and did not record it, so `LOCALS\|` failed. It now declares the local and compiles `LOCAL-INIT`. `{: :}` was already implemented. |
| `(INCLUDE)` | Returns immediately. A bare `INCLUDE` or `FLOAD` never opens the file dialog. A named include works through the colon word. |
| `(LOAD-ENTER)` | Drops the block number. |
| `(LOAD-RUN)` | Drops the block text. `LOAD` and `THRU` in the cold load call these two. |
| `FORGET` | Parses the name and leaves the word in the dictionary. |

## No Windows boot word

Editor and host:

- `EDIT-AT` opens a path at a line. `VIEW` in Hyper calls it.
- `SYSTEM` runs a command string and returns the exit code.
- `XEMIT` emits one xchar as UTF-8. `XC@+` and `XC!+` are already there.

Blocks:

- `BLK` is the block-number variable. `SCR`, `BLOCK-FILE`, and the block buffer words exist. `LOAD` still dies in the two stubs above.

Dictionary:

- `USER-DICT` is the base of the user dictionary.
- `GROWMEMORYMB` grows that dictionary once per session.

Native code, used by the assembler and the emitter:

- `ALLOCATE-EXEC`
- `FREE-EXEC`
- `MPROTECT`
- `ICACHE-INVAL`
- `JIT-WPROTECT`
- `CALL-NATIVE`
- `CALL-NATIVE-LEAF`
- `NATIVE-SMOKE`
- `DOCON-ADDR`
- `(DOCON)`

Windows `CONSTANT` is `CREATE , DOES> @`, so there is no separate constant runtime for `DOCON-ADDR` to return.

## Names that are not missing features

`(INCLUDED)` is the colon word `INCLUDED` in `kernel2.fth`. Named `INCLUDE` and `FLOAD` already use it. `(NEXT)` is only a dictionary header on the ITC dispatcher, which is in the kernel.

The other 22 Mac-only names are `FLAG_EMM` labels on internal stand-alone code, not words you type: `(SA-FILES)`, `(SA-PRINT)`, `(SA-FLOAT)`, `(FILE-OP-CALL)`, `(PUTCHAR)`, `(GETCHAR)`, `(WRITE-STDOUT)`, `(READ-LINE)`, `(NEXT-WORD)`, `(FIND-WORD)`, `(COMPILE-CELL)`, `(CURSOR-LOAD)`, `(CURSOR-STORE)`, `(SOURCE-END)`, `(LOAD-BASE)`, `(DIGIT-CHAR)`, `(I64>STR)`, `(U64>STR)`, `(PRINT-STRING)`, `(UDIVMOD128)`, `(.)`, `(U.)`. File access, printing, and parsing are already ordinary Windows words.

One behavior gap was not a missing word: a trailing dot was not a double literal, which is why `123.` failed in the Oct 16 ANS-VALIDATE run. The number parser now accepts it.

## Fixed after this list

- `(LOCAL)` now declares locals for `LOCALS|` and compiles `LOCAL-INIT` when the count is zero. `{: :}` is unchanged.
- A token that ends in `.` is a double literal. `123.` leaves 123 under 0. The high cell is the sign extension.

## ANS-VALIDATE after those fixes

The same `FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth` run, after the normal boot, was repeated on Oct 16, 2026.

Core through File-Access finished with an empty stack and no failures. Double and Locals are in that stretch.

Block printed `BL-T ?`, `FAIL: LOAD`, then `BLK ?`. The process then faulted. XChar, Float, and Host did not run. There is no final pass count.
