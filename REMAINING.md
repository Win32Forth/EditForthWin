# Remaining assembly words

Updated Oct 16, 2026 for version 1.2.0 (ARM64 `1.2.0`, x64 `1.2.0-x64`, built Oct 16, 2026 10:43 AM). The Mac kernel (`EditForth/Forth/Kernel/forth.s`) has 401 boot words. The Windows ARM64 kernel has 372. Twenty-nine Mac names have no Windows header. The x64 kernel is a translation of this ARM64 set, so it has the same words. No boot words were added for 1.2.0. `Forth/boot-fix.fth` is a cold-start suffix after `xref.fth`. It redefines `SYNONYM`, `REPLACES`, and `SUBSTITUTE`. The seven Mac cold-load files are unchanged.

Punctuation names (`;` `,` `\` `\S` `S"` `(S")` `."` `S\"` `C"` `(C")` `C,` `TIME&DATE`) are present on both sides.

## Done

These bodies are in the kernel and were checked on both `fortharm64.exe` and `forthx64.exe`. The Qt editors were not rebuilt.

- `(LOCAL)` declares locals for `LOCALS|` and compiles `LOCAL-INIT` when the count is zero. `{: :}` is unchanged.
- A token that ends in `.` is a double literal. `123.` leaves 123 under 0. The high cell is the sign extension.
- `(F-OP)` runs the floating-point opcode. The IEEE stack is in `Forth/host/float_win.c`, depth 16, default precision 6. `FLIT` pushes the inline bits that `FLITERAL` compiles. `S" FLOATING" ENVIRONMENT?` and `S" BLOCK" ENVIRONMENT?` are true. `S" FLOATING-STACK" ENVIRONMENT?` is 16. `MAX-FLOAT` is the Mac value, bits `0x7FEFFFFFFFFFFFFF`. A token such as `1.5E0`, `1E-12`, `0E`, or `1.E` is a float literal. In HEX, `1E` stays the integer `0x1E`. `'z'`, `'Z'`, and `'''` are character literals. `>FLOAT` accepts an empty string, or a string of only whitespace, as zero. Whitespace mixed with other characters is rejected. `F.`, `FS.`, `FE.`, and `REPRESENT` follow the Mac pictures. `FACILITY` and `FACILITY-EXT` stay false.
- `S\"` honors the escapes `\a \b \e \f \l \m \n \q \r \t \v \z \" \\` and `\xHH`. Two interpret uses in a row keep two 256-byte buffers. Interpret `S"` still returns a pointer into `SOURCE`.
- A block file path that starts with `~` or `~/` expands to the user profile. `CREATE-FILE` creates missing parent directories. The Hayes block file stays `~/Library/Application Support/64Forth/hayes-blocks.blk`.
- A `(` comment reads through to the closing `)` across lines while a file is being included.
- `THROW` keeps the `CATCH` snapshot when the stack is the same depth or shallower, and takes the live cell under the saved stack pointer when the stack is deeper. An unknown word prints `name ?` and continues at the prompt. Inside `CATCH` it prints that and then throws -13.
- `SYNONYM` in `boot-fix.fth` runs the original definition and then discards the old name that definition leaves in the input. `REPLACES` and `SUBSTITUTE` in that same file match substitution names in either case and copy the source aside before writing, so an overlapping destination does not eat the pattern.
- `(INCLUDE)` calls `host_include_dialog`. The standalone console shows the Windows open-file dialog. Cancel returns without loading a file. `--agent` and the Qt companion have no console window, so a bare `INCLUDE` or `FLOAD` there returns at once. A named include still goes through the colon word `INCLUDED`. The windowed dialog has not been clicked in a test.
- `(LOAD-ENTER)` saves the outer source and stores the block number in `BLK`. `(LOAD-RUN)` interprets the block text and restores that source when the buffer ends. `BLK` is the cell those words use. With no block file, `BLOCK` blanks the buffer. A short program moved into block 1, then `1 LOAD`, ran and left `BLK` at 0. `2 3 THRU` loads blocks 2 and 3.
- `FORGET` parses the name and removes that word and everything newer. An unknown name prints `name ?` and abandons the rest of the line. A word below the cold-load fence prints `protected (system word)` and stays. Checked for a colon word, an empty colon word, a newer word defined after the forgotten one, `CONSTANT`, and `VALUE`.
- `ALLOCATE-EXEC` reserves a read/write page with `VirtualAlloc`. `FREE-EXEC` releases that base address. A null address returns ior 0. `MPROTECT` uses the Mac bits: 1=read, 2=write, 4=execute. Prot 5 is read/execute. `ICACHE-INVAL` flushes the instruction cache for the range. The host side is `Forth/host/exec_win.c`.
- `CALL-NATIVE` saves the Forth registers and calls the code. On ARM64, x0 is the argument and x19 is the data-stack pointer. `CALL-NATIVE-LEAF` passes x0=0 and a built-in data stack. On x64 the translated call uses the Windows argument registers, so it runs x64 machine code. It does not run ARM64 opcodes. `NATIVE-SMOKE` maps a page, writes a leaf that returns 7, protects it, calls it, and frees it. It returned 0 on both builds. A direct `CALL-NATIVE` and `CALL-NATIVE-LEAF` of that same leaf also returned 7.
- `JIT-WPROTECT` drops the flag and records 0 or 1. Windows has no per-thread `MAP_JIT` switch, so this word does not change page protection. The assembler uses `MPROTECT`.
- `(DOCON)` pushes the cell at CFA+16. `DOCON-ADDR` is that code address. The colon word `CONSTANT` is still `CREATE , DOES> @`, so a normal constant uses `DOES>` rather than `(DOCON)`. Patching a `CREATE` word's code field to `DOCON-ADDR` made it push 42. `' (DOCON) @` matches `DOCON-ADDR`. `(DOCON)` is moved into `EMITTER` by the cold load. `DOCON-ADDR` stays in `FORTH`.

The assembler and the emitter were not loaded.

## Hayes

`FROMLIB FLOAD Testing/HayesTest/HayesTest.fth` was run on `fortharm64.exe` and `forthx64.exe` on Oct 16, 2026. Both finished with no `HAYES FAIL` banner. Core through Block, the floating-point sections, and Paranoia reported 0. The suite's own summary line was `ALL COUNTS ZERO`. The Qt editors were not rebuilt. Help > About reads the version from the Forth engine, so it shows 1.2.0 from these executables.

## Still no Windows boot word

Editor and host:

- `EDIT-AT` opens a path at a line. `VIEW` in Hyper calls it.
- `SYSTEM` runs a command string and returns the exit code.
- `XEMIT` emits one xchar as UTF-8. `XC@+` and `XC!+` are already there.

Dictionary:

- `USER-DICT` is the base of the user dictionary.
- `GROWMEMORYMB` grows that dictionary once per session.

## Names that are not missing features

`(INCLUDED)` is the colon word `INCLUDED` in `kernel2.fth`. Named `INCLUDE` and `FLOAD` already use it. `(NEXT)` is only a dictionary header on the ITC dispatcher, which is in the kernel.

The other 22 Mac-only names are `FLAG_EMM` labels on internal stand-alone code, not words you type: `(SA-FILES)`, `(SA-PRINT)`, `(SA-FLOAT)`, `(FILE-OP-CALL)`, `(PUTCHAR)`, `(GETCHAR)`, `(WRITE-STDOUT)`, `(READ-LINE)`, `(NEXT-WORD)`, `(FIND-WORD)`, `(COMPILE-CELL)`, `(CURSOR-LOAD)`, `(CURSOR-STORE)`, `(SOURCE-END)`, `(LOAD-BASE)`, `(DIGIT-CHAR)`, `(I64>STR)`, `(U64>STR)`, `(PRINT-STRING)`, `(UDIVMOD128)`, `(.)`, `(U.)`. File access, printing, and parsing are already ordinary Windows words.

## ANS-VALIDATE

`FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth` was run after the normal boot on Oct 16, 2026, before the words in Done were finished.

Core through File-Access finished with an empty stack and no failures. Double and Locals are in that stretch.

Block printed `BL-T ?`, `FAIL: LOAD`, then `BLK ?`. The process then faulted. XChar, Float, and Host did not run. There is no final pass count. That suite has not been run again. The 1.2.0 check is the Hayes suite above, not a new ANS-VALIDATE pass.
