# Remaining assembly words

Updated Oct 18, 2026 for version 1.2.2 on ARM64 (`1.2.2`, built Oct 18, 2026 5:44 AM). x64 stays `1.2.1-x64`, built Oct 16, 2026 7:02 PM. The Mac kernel (`EditForth/Forth/Kernel/forth.s`) has 401 boot words. The Windows ARM64 kernel had 372 at 1.2.0. 1.2.1 adds five: `EDIT-AT`, `SYSTEM`, `XEMIT`, `USER-DICT`, and `GROWMEMORYMB`. The x64 kernel is a translation of this ARM64 set, so it has the same words. `Forth/boot-fix.fth` is a cold-start suffix after `xref.fth`. It redefines `SYNONYM`, `REPLACES`, and `SUBSTITUTE`. A copy is shipped at `Forth/Resources/Library/Sources/boot-fix.fth` so `VIEW` can open it. The seven Mac cold-load files are unchanged.

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
- `EDIT-AT` takes a path and a line and opens that place in the editor. It does not open a file dialog.
- `SYSTEM` runs the command string and returns the process exit code, or -1 when the command does not start.
- `XEMIT` emits one xchar as UTF-8. The assembly label is `XXCHAR_EMIT`. `EMIT` is unchanged.
- `USER-DICT` returns the base of the user dictionary.
- `GROWMEMORYMB` grows that dictionary to the given number of megabytes once per session. It does not shrink, and the maximum is 256.

The assembler and the emitter were not loaded for the checks above. An unknown word typed at the console stops on the first name, turns compiling off, and clears both stacks. `.` on an empty stack prints `0 stack underflow` and returns to `ok(0)>`. `VIEW` stamps come from Hyper after `HYPER-REINDEX`. `DUP` opens the running kernel's `prims.asm`. Cold colon words such as `VIEW-LINE` open `Library/Sources/kernel1.fth`. The shipped autoload still leaves Hyper commented out.

## Emitter on ARM64

1.2.2 adds the stand-alone file and float spans. `(SA-PRINT)` was already in 1.2.1. `ALLOCATE` and `FREE` now have end labels so the slicer can copy them and bind `host_alloc` / `host_free`.

`FROMLIB FLOAD Emitter/emitter.fth` loads the slicer. On Windows, `EMIT-APP` does not call `app-build.sh`. `Library/Emitter/app-win.fth` writes `<outdir>/<NAME>/<NAME>.exe` plus `app.img`. The exe is `Library/Emitter/runner/emit-win.exe`. It loads the image, binds the graphics host slots, and opens one window. Text arrives through `(APP-BLIT)`. Depth 4 on `(APP-CBLIT)` is a list of squares, five cells each: `color x y w h`, colors as 32-bit BGR. `(APP-KEY)` waits until a key arrives in that window. `KEY` is the console key and is not valid inside the emitted exe.

`(APP-OPEN)` and the other `(APP-*)` names are moved into `GRAPHICS` at cold start. A source file that calls them needs `ALSO GRAPHICS`.

Checked on ARM64: `sa-files-smoke.fth` printed 42, `sa-float-smoke.fth` printed 7, and `emit-win-out\T-WIN\T-WIN.exe` showed `hello 42` plus blue, green, and red squares. `EMIT-WINDOW-APP` is not that path yet. The x64 emitter was not built. Hayes and ANS-VALIDATE were not run for 1.2.2.

## Hayes

`FROMLIB FLOAD Testing/HayesTest/HayesTest.fth` was run on `fortharm64.exe` and `forthx64.exe` on Oct 16, 2026, before the 1.2.1 kernel changes. Both finished with no `HAYES FAIL` banner. Core through Block, the floating-point sections, and Paranoia reported 0. The suite's own summary line was `ALL COUNTS ZERO`. That run was not repeated for 1.2.1. Help > About reads the version from the Forth engine.

## Still no Windows boot word

The five names that were open at 1.2.0 are in the kernel. The ARM64 stand-alone spans for print, files, and float are in the kernel. What remains for a graphics application is `EMIT-WINDOW-APP`. The x64 kernel does not include the new spans.

## Names that are not missing features

`(INCLUDED)` is the colon word `INCLUDED` in `kernel2.fth`. Named `INCLUDE` and `FLOAD` already use it. `(NEXT)` is only a dictionary header on the ITC dispatcher, which is in the kernel.

The other 22 Mac-only names are `FLAG_EMM` labels on internal stand-alone code, not words you type: `(SA-FILES)`, `(SA-PRINT)`, `(SA-FLOAT)`, `(FILE-OP-CALL)`, `(PUTCHAR)`, `(GETCHAR)`, `(WRITE-STDOUT)`, `(READ-LINE)`, `(NEXT-WORD)`, `(FIND-WORD)`, `(COMPILE-CELL)`, `(CURSOR-LOAD)`, `(CURSOR-STORE)`, `(SOURCE-END)`, `(LOAD-BASE)`, `(DIGIT-CHAR)`, `(I64>STR)`, `(U64>STR)`, `(PRINT-STRING)`, `(UDIVMOD128)`, `(.)`, `(U.)`. File access, printing, and parsing are already ordinary Windows words.

## ANS-VALIDATE

`FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth` was run after the normal boot on Oct 16, 2026, before the words in Done were finished.

Core through File-Access finished with an empty stack and no failures. Double and Locals are in that stretch.

Block printed `BL-T ?`, `FAIL: LOAD`, then `BLK ?`. The process then faulted. XChar, Float, and Host did not run. There is no final pass count. That suite has not been run again. The 1.2.0 Hayes run above is the last full suite. 1.2.1 did not re-run ANS-VALIDATE.
