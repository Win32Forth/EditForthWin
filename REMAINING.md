# Remaining assembly words

Updated Oct 26, 2026 11:15 AM for version 2.5.1.0. ARM64 is `2.5.1.0`. x64 is `2.5.1.0-x64`. The kernel stamp is Oct 26, 2026 11:15 AM. The executables are not rebuilt in this commit. The Mac kernel (`EditForth/Forth/Kernel/forth.s`) has 401 boot words. The Windows ARM64 kernel had 372 at 1.2.0. 1.2.1 adds five: `EDIT-AT`, `SYSTEM`, `XEMIT`, `USER-DICT`, and `GROWMEMORYMB`. The x64 kernel is a translation of this ARM64 set, so it has the same words. `Forth/boot-fix.fth` is a cold-start suffix after `xref.fth`. It redefines `SYNONYM`, `REPLACES`, and `SUBSTITUTE`. A copy is shipped at `Forth/Resources/Library/Sources/boot-fix.fth` so `VIEW` can open it. The seven Mac cold-load files are unchanged.

Punctuation names (`;` `,` `\` `\S` `S"` `(S")` `."` `S\"` `C"` `(C")` `C,` `TIME&DATE`) are present on both sides.

## Done

These bodies are in the kernel and were checked on both `fortharm64.exe` and `forthx64.exe`. Both editors keep the cold-load lines under Help → EditForthWin Startup Messages.

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

The assembler and the emitter were not loaded for the checks above. An unknown word typed at the console stops on the first name, turns compiling off, and clears both stacks. `.` on an empty stack prints `0 stack underflow` and returns to `ok(0)>`. `VIEW` stamps come from Hyper after `HYPER-REINDEX`. `DUP` opens the running kernel's `prims.asm`. Cold colon words such as `VIEW-LINE` open `Library/Sources/kernel1.fth`. The shipped autoload loads the Emitter, then the Hyper text lines, then `HYPER-REINDEX`.

## Emitter on ARM64

1.2.2 adds the stand-alone file and float spans. `(SA-PRINT)` was already in 1.2.1. `ALLOCATE` and `FREE` now have end labels so the slicer can copy them and bind `host_alloc` / `host_free`.

`FROMLIB FLOAD Emitter/emitter.fth` loads the slicer. On Windows, `EMIT-APP` does not call `app-build.sh`. `Library/Emitter/app-win.fth` writes `<outdir>/<NAME>/<NAME>.exe` plus `app.img`. The exe is `Library/Emitter/runner/emit-win.exe`. It loads the image, binds the graphics host slots, and opens one window. Text arrives through `(APP-BLIT)`. Depth 4 on `(APP-CBLIT)` is a list of squares, five cells each: `color x y w h`, colors as 32-bit BGR. `(APP-KEY)` waits until a key arrives in that window. `KEY` is the console key and is not valid inside the emitted exe.

`(APP-OPEN)` and the other `(APP-*)` names are moved into `GRAPHICS` at cold start. A source file that calls them needs `ALSO GRAPHICS`.

Checked on ARM64: `sa-files-smoke.fth` printed 42, `sa-float-smoke.fth` printed 7, and `T-WIN\T-WIN.exe` beside the source file showed `hello 42` plus blue, green, and red squares. `EMIT-WINDOW-APP` is not that path yet. On x64, `forthx64.exe` has the same print, file, and float spans. An agent load printed `42`, wrote and read `hi`, and `3 S>F 4 S>F F+ F>S` printed `7`. `EMIT-APP` from `forthx64.exe` packs `Library/Emitter/runner/emit-win-x64.exe`. A rebuilt `HI\HI.exe` printed `42`, and `T-WIN\T-WIN.exe` showed `hello 42` plus the same three squares. Hayes and ANS-VALIDATE were not run for 1.2.2.

1.2.3 does not add boot words. `HYPER-REINDEX` builds `Config/HYPER.SPECS` from `Config/HYPER.CFG` and indexes `Library` plus the running kernel assembly. Ctrl-click opens that stamp through the same path resolution as `VIEW`, under `Documents\EditForthWin\Library\Sources`, and the editor puts the file in browse mode. Hayes and ANS-VALIDATE were not run for 1.2.3.

1.2.4 does not add boot words. The emitter packs programs that use `THROW`, `*/`, `TIME&DATE`, and the graphics window. Windows `THROW` has no end label, so on ARM64 the slicer copies the body through the next boot word and turns the host quit branch into a no-op. `CATCH` still receives the code. `DEPTH`, `SP0`, `CLEARSTACK`, and `EXECUTE` read the runner's empty data stack, so `APP-NAME` gets the real string and the window title is the program name. `*/` copies the unsigned divide span. `TIME&DATE` is host slot 27. An outdir of `"."` is the folder of the last included source, so the bundle sits beside that file. The runner stretches the picture when the window is resized, paints light text on a dark cell, loads BMP, PNG, JPEG, GIF, and TIFF through WIC, and opens the image dialog. `GCLOCK`, `IMAGEVIEW64`, and `MIDNIGHT` were emitted on ARM64 and those windows ran. The x64 runner is built from the same C source. x64 `THROW` still has no span, so a program that reaches `THROW` does not emit on x64. Hayes and ANS-VALIDATE were not run for 1.2.4.

1.2.5 does not add boot words. On x64, `THROW` is a fixed 512-byte body, `EXECUTE`, `DEPTH`, `SP0`, and `CLEARSTACK` read the runner's empty data stack, and `*/` copies the unsigned divide helper. `GCLOCK`, `IMAGEVIEW64`, and `MIDNIGHT` were emitted on x64 and those windows ran. The Windows packer moves `<NAME>.img` into the bundle folder beside `<NAME>.exe` and `app.img`. The runner opens the Open and Save dialogs, then reads or writes the chosen file. ARM64 `VED64` opened Save File and Open File, wrote the buffer, loaded a file back, and S on the quit prompt saved and quit. Hayes and ANS-VALIDATE were not run for 1.2.5.

1.2.6 does not add boot words. On x64, a CALL or JMP that lands in any bounded boot word is copied, not only a `FLAG_EMM` helper, and a CALL into the unsigned divide helper is copied the same way as a JMP. The byte `E8` inside `sub r64, imm8` in `(LOCAL-FRAME-EXIT)` is not treated as a CALL. That was the `op 232` abort while emitting `VED64`. `VED64` was emitted with the x64 engine and the build finished. Hayes and ANS-VALIDATE were not run for 1.2.6.

1.2.7 does not add boot words. The x64 kernel is the 1.2.6 engine rebuilt as `1.2.7-x64` so a real x64 PC can install this build. `VED64` emitted with that engine stayed open on the development VM, window title `64Forth VED64`. The close seen on a real x64 machine was not reproduced here. ARM64 was not rebuilt. Hayes and ANS-VALIDATE were not run for 1.2.7.

1.2.8 does not add boot words. ARM64 and x64 were both rebuilt. On Windows, `FALIGNED` and `DFALIGNED` return the next 8-byte-aligned address, and `SFALIGNED` returns the next 4-byte-aligned address. The ANS-VALIDATE host checks compare those addresses. That host section is 40 passed, 0 failed on `fortharm64.exe` and on `forthx64.exe`. The rest of ANS-VALIDATE was not run again, and Hayes was not run for 1.2.8.

1.2.9 does not add boot words. ARM64 and x64 were both rebuilt. `Sample/CLOCK.fth` aligns after `,"`, and `FOR`/`NEXT` counts from n down through 0, so the box, the hour scale, and the bars finish and the clock loop runs. `EMIT-WINDOW-APP` closes the host graphics window and clears `G-OPEN?`, `G-BUF`, `G-DIRTY?`, `G-CX`, and `G-CY` before the image is saved. `DATA-END` walks `FORTH-WORDLIST` as well as the registered wordlists, and keeps the wordlist index on the data stack, so a `CREATE` body such as the roman numerals is copied through to the next header. CLOCK was emitted on ARM64 and on x64. Each `CLOCK.exe` stayed open with window title `CLOCK`, and the image contains the roman digit table. Hayes and ANS-VALIDATE were not run for 1.2.9.

1.3.0 does not add boot words. ARM64 and x64 were both rebuilt. Ctrl+click VIEW on x64 stays in the editor. The companion calls `host_find_word` so the translated word finder receives the token and the virtual register file is restored. A breakpoint toggle uses that same entry. Ask Forth's starter Ollama profile is `qwen2.5-coder:7b`. `scripts\release.ps1 validate` runs ANS-VALIDATE and Hayes on both executables. ANS-VALIDATE is 394 passed, 0 failed on `fortharm64.exe` and on `forthx64.exe`. Hayes finished with `ALL COUNTS ZERO — PASS` on both.

1.3.1 does not add boot words. ARM64 and x64 were both rebuilt. Ask Forth floats in its own window. Undock on the title row, or View → Undock Ask Forth, moves the panel. Dock, View → Dock Ask Forth, or closing that window puts it back beside the editor. View → Ask Forth still hides the panel. The window size is remembered. A circled ? beside Ask Forth and beside EditForthWin Agent shows the help that used to sit in the panel. Capture Selected to Prompt is removed. The Prompt label sits just above the edit box. `scripts\release.ps1 validate` runs ANS-VALIDATE and Hayes on both executables. ANS-VALIDATE is 394 passed, 0 failed on `fortharm64.exe` and on `forthx64.exe`. Hayes finished with `ALL COUNTS ZERO — PASS` on both.

2.3.9.0 adds `(HX-BG-REINDEX) ( -- n )`. It starts a second Forth process that writes `Config\HYPER.NDX.building`. The host swaps that file over `Config\HYPER.NDX` after `HX-BUILD-OK` and a zero exit. Return 1 means the new file is already in place and Forth reloads it. Return 0 means up to date, already running, failed, or still running in the editor. The editor shows the result under Engine connected for 3 seconds. A standalone console waits. Unchanged sources skip the scan. The x64 word is the ARM64 word translated by hand into `Forth\kernel\x64\asm\prims_k2.asm`. `Forth\host\hyper_win.c` is the host. Hayes and ANS-VALIDATE were not run for 2.3.9.0.

2.5.0.0 does not add boot words. EditForth 2.5.0 makes the Mac editor and the Forth engine one application. Windows already uses a separate editor executable and `fortharm64.exe` or `forthx64.exe`. Those stay separate. Hayes and ANS-VALIDATE were not run for 2.5.0.0.

2.5.1.0 does not add boot words. `BYE` already closes the editor. `EMIT-APP` and `EMIT-WINDOW-APP` write under `<source-dir>\<STEM>\`. INCLUDE on a clean Untitled tab opens the file, then runs `ANEW` and INCLUDE. Launch and Update User Data copy a shipped Library, AutoLoad, or Docs file when it is missing or older. A newer Documents file stays. Config is not replaced. `FORGET` calls `host_forget_drop_stale` after the registry prune, and only on the success path. A reclaimed vocabulary leaves the wordlist registry, the search order, and CURRENT. An empty search order becomes FORTH. The Mac KEY relocator change does not apply. `VIEW '` was already indexed from the unquoted `BOOT_WORD` line. Hayes and ANS-VALIDATE were not run for 2.5.1.0.

## Hayes

`FROMLIB FLOAD Testing/HayesTest/HayesTest.fth` was run on `fortharm64.exe` and `forthx64.exe` on Oct 16, 2026, before the 1.2.1 kernel changes. Both finished with no `HAYES FAIL` banner. Core through Block, the floating-point sections, and Paranoia reported 0. The suite's own summary line was `ALL COUNTS ZERO`. That run was not repeated for 1.2.1. Help > About reads the version from the Forth engine.

## Still no Windows boot word

The five names that were open at 1.2.0 are in the kernel. The stand-alone spans for print, files, and float are in the ARM64 kernel and the x64 kernel. `EMIT-APP` on x64 writes a bundle with `emit-win-x64.exe`. `EMIT-WINDOW-APP` is the graphics emit on both architectures.

## Names that are not missing features

`(INCLUDED)` is the colon word `INCLUDED` in `kernel2.fth`. Named `INCLUDE` and `FLOAD` already use it. `(NEXT)` is only a dictionary header on the ITC dispatcher, which is in the kernel.

The other 22 Mac-only names are `FLAG_EMM` labels on internal stand-alone code, not words you type: `(SA-FILES)`, `(SA-PRINT)`, `(SA-FLOAT)`, `(FILE-OP-CALL)`, `(PUTCHAR)`, `(GETCHAR)`, `(WRITE-STDOUT)`, `(READ-LINE)`, `(NEXT-WORD)`, `(FIND-WORD)`, `(COMPILE-CELL)`, `(CURSOR-LOAD)`, `(CURSOR-STORE)`, `(SOURCE-END)`, `(LOAD-BASE)`, `(DIGIT-CHAR)`, `(I64>STR)`, `(U64>STR)`, `(PRINT-STRING)`, `(UDIVMOD128)`, `(.)`, `(U.)`. File access, printing, and parsing are already ordinary Windows words.

## ANS-VALIDATE

`FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth` was run after the normal boot on Oct 16, 2026, before the words in Done were finished.

Core through File-Access finished with an empty stack and no failures. Double and Locals are in that stretch.

Block printed `BL-T ?`, `FAIL: LOAD`, then `BLK ?`. The process then faulted. XChar, Float, and Host did not run. There is no final pass count. That suite has not been run again. The 1.2.0 Hayes run above is the last full suite. 1.2.1 did not re-run ANS-VALIDATE.
