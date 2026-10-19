# EditForthWin

Windows sibling of [EditForth](https://github.com/Win32Forth/EditForth). This tree holds the Forth console and the Qt editor.

**Version 1.2.8** on ARM64 and **1.2.8-x64** on x64. ARM64 was built Oct 19, 2026 10:29 AM. x64 was built Oct 19, 2026 10:29 AM.

Starting `fortharm64.exe` or `forthx64.exe` opens a window. The cold-load lines appear, then the banner, then a prompt. The editor keeps those same lines under Help → EditForthWin Startup Messages and starts the Forth pane at the banner:

```
=== EditForthWin 1.2.8 === Oct 19, 2026 10:29 AM ===
ok(0)>
```

The banner matches the Mac EditForth console. The version, the date and time, and the console window title live in the kernel assembly, so the ARM64 and x64 images can differ. ARM64 is `Forth\kernel\arm64\identity.asm` (`1.2.8`, `Oct 19, 2026 10:29 AM`, window title `EditForthWin Arm64`). x64 is `Forth\kernel\x64\identity.asm` (`1.2.8-x64`, `Oct 19, 2026 10:29 AM`, window title `EditForthWin x64`). The console prints the version and the date, and Help > About EditForthWin shows that pair after the engine reports it. The Hayes suite passed on both executables for 1.2.0 on Oct 16, 2026. It was not run again for 1.2.1. `REMAINING.md` records that run and the boot words that are still absent. Return evaluates the line at the prompt. Up and Down recall earlier lines. `BYE` closes the window.

1.2.1 adds `EDIT-AT`, `SYSTEM`, `XEMIT`, `USER-DICT`, and `GROWMEMORYMB`. `XEMIT` sends one xchar as UTF-8. `EMIT` is unchanged. An unknown word at the console stops on the first name, turns compiling off, and clears both stacks. `.` on an empty stack prints `0 stack underflow` and returns to `ok(0)>`. `VIEW` of `DUP` opens the running kernel assembly, `Library/Sources/arm64/prims.asm` or `Library/Sources/x64/prims.asm`. `VIEW` of a cold colon word such as `VIEW-LINE` opens that word's file under `Library/Sources`, for example `kernel1.fth` line 69. Those stamps come from Hyper. The shipped `AutoLoad\autoload.fth` loads the Emitter. Hyper stays commented. Uncomment the Hyper lines, and leave `HYPER-REINDEX` after `REQUIRE` returns, when that index should rebuild at boot. The editor can find and replace in the open file, search a folder, diff a file against disk, and open a page in the system browser. While a debug step is showing source, that pane stays in browse mode with an Edit button, and the caret stays in the Forth console except for a double-click. View → Ask Forth (Ctrl+Alt+A) streams a reply into Documents\EditForthWin\AskForth\AskForth-N.fth. Hybrid and Semantic library search uses a local nomic-embed-text index and falls back to keyword matching until that index is ready. 1.2.2 is on ARM64 and x64. The stand-alone spans `(SA-PRINT)`, `(SA-FILES)`, and `(SA-FLOAT)` are in both kernels. `EMIT-APP` on Windows writes a folder, not a Mac `.app`: `NAME.exe` and `app.img` are the `64EMIT02` image. ARM64 packs `emit-win.exe`. x64 packs `emit-win-x64.exe`. A word that calls `(APP-OPEN)`, `(APP-BLIT)`, `(APP-CBLIT)`, and `(APP-KEY)` draws text and color squares in that window and waits for a key. `(APP-*)` names live in `GRAPHICS`, so the source needs `ALSO GRAPHICS`. Depth 4 on `(APP-CBLIT)` is a Windows square list of `color x y w h` cells. `EMIT-WINDOW-APP` still shares the Mac graphics path and is not the Windows graphics emit. The seven cold-load sources are unchanged. The Hayes suite was not run again.

1.2.3 keeps that kernel. `HYPER-REINDEX` reads `Config/HYPER.SPECS` from `Config/HYPER.CFG` the way the Mac host does. Blank lines and `#` comments are skipped, `;` ends the file, `SPECS` adds a path, and `*EXCLUDE` drops a name. A spec that contains `*` or `?` walks `Library`. The host serves that list when Forth opens `Config/HYPER.SPECS`, so a normal boot no longer prints `HX: HYPER.SPECS unavailable — fallback list`. The index is `Library` sources plus the running architecture's kernel assembly. `VIEW DUP` opens `Library/Sources/arm64/prims.asm` or `Library/Sources/x64/prims.asm` under `Documents\EditForthWin`. Ctrl-click in a source tab or in the Forth console uses that same open, and the file is browse mode. A name that is not in the dictionary still reports `undefined: NAME`. The Edit button on the banner turns editing back on. Hayes and ANS-VALIDATE were not run for 1.2.3.

1.2.4 does not add boot words. The emitter packs programs that use `THROW`, `*/`, `TIME&DATE`, and the graphics window. Windows `THROW` has no end label, so on ARM64 the slicer copies the body through the next boot word and turns the host quit branch into a no-op. `CATCH` still receives the code. `DEPTH`, `SP0`, `CLEARSTACK`, and `EXECUTE` read the runner's empty data stack, so `APP-NAME` gets the real string and the window title is the program name. `*/` copies the unsigned divide span. `TIME&DATE` is host slot 27. An outdir of `"."` is the folder of the last included source, so the bundle sits beside that file. The runner stretches the picture when the window is resized, paints light text on a dark cell, loads BMP, PNG, JPEG, GIF, and TIFF through WIC, and opens the image dialog. `GCLOCK`, `IMAGEVIEW64`, and `MIDNIGHT` were emitted on ARM64 and those windows ran. The x64 runner is built from the same C source. x64 `THROW` still has no span, so a program that reaches `THROW` does not emit on x64. Hayes and ANS-VALIDATE were not run for 1.2.4.

1.2.5 does not add boot words. On x64, `THROW` is a fixed 512-byte body, `EXECUTE`, `DEPTH`, `SP0`, and `CLEARSTACK` read the runner's empty data stack, and `*/` copies the unsigned divide helper. `GCLOCK`, `IMAGEVIEW64`, and `MIDNIGHT` were emitted on x64 and those windows ran. The Windows packer moves `<NAME>.img` into the bundle folder beside `<NAME>.exe` and `app.img`. The runner opens the Open and Save dialogs, then reads or writes the chosen file. ARM64 `VED64` opened Save File and Open File, wrote the buffer, loaded a file back, and S on the quit prompt saved and quit. Hayes and ANS-VALIDATE were not run for 1.2.5.

1.2.6 does not add boot words. On x64, a CALL or JMP that lands in any bounded boot word is copied, not only a `FLAG_EMM` helper, and a CALL into the unsigned divide helper is copied the same way as a JMP. The byte `E8` inside `sub r64, imm8` in `(LOCAL-FRAME-EXIT)` is not treated as a CALL. That was the `op 232` abort while emitting `VED64`. `VED64` was emitted with the x64 engine and the build finished. An install leaves `Documents\EditForthWin\Library\Emitter` in place when that folder is already there, so copy `Resources\Library\Emitter` over it, or remove it before installing, then restart the editor. Hayes and ANS-VALIDATE were not run for 1.2.6.

1.2.7 does not add boot words. The x64 kernel is the 1.2.6 engine rebuilt as `1.2.7-x64` so a real x64 PC can install this build. `VED64` emitted with that engine stayed open on the development VM, window title `64Forth VED64`. The close seen on a real x64 machine was not reproduced here. ARM64 was not rebuilt. An install leaves `Documents\EditForthWin\Library\Emitter` in place when that folder is already there, so copy `Resources\Library\Emitter` over it, or remove it before installing, then restart the editor and confirm the banner is `=== EditForthWin 1.2.7-x64 === Oct 19, 2026 9:36 AM ===` before emitting. Hayes and ANS-VALIDATE were not run for 1.2.7.

1.2.8 does not add boot words. ARM64 and x64 were both rebuilt. On Windows, `FALIGNED` and `DFALIGNED` return the next 8-byte-aligned address, and `SFALIGNED` returns the next 4-byte-aligned address. The ANS-VALIDATE host checks compare those addresses. That host section is 40 passed, 0 failed on `fortharm64.exe` and on `forthx64.exe`. The rest of ANS-VALIDATE was not run again, and Hayes was not run for 1.2.8. An install leaves `Documents\EditForthWin\Library\Emitter` in place when that folder is already there, so copy `Resources\Library\Emitter` over it, or remove it before installing, then restart the editor. Confirm `=== EditForthWin 1.2.8 === Oct 19, 2026 10:29 AM ===` on ARM64, or `=== EditForthWin 1.2.8-x64 === Oct 19, 2026 10:29 AM ===` on x64, before emitting.

`--agent` runs the same kernel with no window and writes the transcript to the console that launched it:

```bat
fortharm64.exe --agent -e "2 3 + ."
forthx64.exe --agent -e "2 3 + ."
fortharm64.exe --agent --help
```

## Layout

`Forth` is the interpreter. `Edit` is the Qt editor. `build.bat` at the project root builds the ARM64 pair. Forth objects and `fortharm64.exe` go in `Forth\build\arm64\`. The editor executable is `Edit\build\arm64\editforthwinarm64.exe`. `build-x64.bat` builds `Forth\build\x64\forthx64.exe` and `Edit\build\x64\editforthwinx64.exe`. Each editor starts the Forth executable for its own architecture.

The ARM64 kernel under `Forth\kernel\arm64` is indirect-threaded code with TOS in `x20`, the same register map as the Mac kernel. `NEXT` loads a code field and jumps to it. Assembly words use `BOOT_WORD` rows and the Mac header: counted help, counted name, link, flags, code field. `Forth\host\main.c` is the C host. Windows calls stay there. `Forth\include\kernel_api.h` exposes `kernel_init`, `kernel_eval`, `kernel_set_emit`, and `kernel_set_key`.

Cold start interprets one blob of `kernel1.fth`, `kernel2.fth`, `vocemit.fth`, `app-output.fth`, `app-points.fth`, `vocsys.fth`, and `xref.fth`, then the Windows suffix `Forth\boot-fix.fth`. Those seven files stay byte-identical to the Mac sources. Other files load with `INCLUDE`. The x64 kernel is that same machine. Hand-written x64 sources are `Forth\kernel\x64\identity.asm` and `Forth\kernel\x64\vmregs.asm`. `GrokTools\arm64_to_ml64.py` translates the ARM64 sources and writes ml64 into `Forth\kernel\x64\asm`. Those assembly files are in this repository, so a clone can be read and built without a private tools folder. `build-x64.bat` runs the translator, then assembles that directory and links `forthx64.exe` and the x64 editor. Object files and executables under `Forth\build` and `Edit\build` are not kept in git. The x64 Qt kit on this machine is `C:\Qt\6.11.3\msvc2022_64`.

## Build

From this directory:

```bat
build.bat
```

`build.bat` writes `Forth\build\arm64\fortharm64.exe` and `Edit\build\arm64\editforthwinarm64.exe`. It uses Qt 6.11.3 at `C:\Qt\6.11.3\msvc2022_arm64` and CMake at `C:\Qt\Tools\cmake-4.4.4-windows-arm64`. `build-x64.bat` writes `Forth\build\x64\forthx64.exe` and `Edit\build\x64\editforthwinx64.exe`, using Qt at `C:\Qt\6.11.3\msvc2022_64`. In VS Code, Ctrl+Shift+B builds the ARM64 pair. The **build x64** task runs `build-x64.bat`. F5 uses the selected launch entry: Run ARM64 Forth, Run Editor, Run x64 Forth, or Run x64 Editor. Close a running `fortharm64.exe` or `forthx64.exe` before rebuilding that one, or the linker cannot replace it.

`Install\build-installers.bat` writes two per-user installers, `dist\EditForthWin-1.2.8-arm64.exe` and `dist\EditForthWin-1.2.8-x64.exe`. Build both architectures first. Each one installs that architecture's editor, Forth program, and `Forth\Resources` under `%LOCALAPPDATA%\Programs\EditForthWin-ARM64` or `EditForthWin-x64`. It then copies `Library`, `AutoLoad`, `Docs`, and `Config` into `Documents\EditForthWin`. A file that is already there is left as it is. The tasks page offers a desktop shortcut to the editor. The shortcut is not created unless that box is checked. Uninstall removes the program and does not remove `Documents\EditForthWin`.

## Editor

The editor opens one window with a tab per file, Consolas, line numbers, and New, Open, Save, and Save As. A Forth pane under the tabs launches `fortharm64.exe` or `forthx64.exe` with `--companion`, matching the editor that is running, and shows the banner, then `ok(n)>`. Help → EditForthWin Startup Messages shows the cold-load lines. Return in that pane runs the line. Above that pane, the status strip shows whether Forth is connected and, while the stepper is armed, the paused word. The debug bar under it steps, continues, and stops. Letter keys stay in the editor. Undock moves that same console into a window titled with the engine's console name, `EditForthWin Arm64` or `EditForthWin x64`. Dock puts it back. Closing the Forth window hides the transcript and leaves the engine running. Unhide Forth shows it again. The choice is remembered.

Bare `EDIT` opens a file into a tab. `EDIT` with a name opens that file, and `FROMLIB EDIT sample\clock.fth` opens the copy under `Documents\EditForthWin\Library`. Quotes around the name are optional. `FROMLIB` does not change the Forth directory. Bare `FLOAD` or `INCLUDE` loads the file you pick. Those dialogs, and File > Open, list `.fth`, `.fs`, `.4th`, `.f`, and `.txt`. They start in the current Forth directory, and you can navigate from there. A path that contains a quote, or is longer than 255 characters, is not loaded.

`BYE` in the Forth pane closes the editor. Unsaved files are asked about first. Cancel leaves both the editor and Forth running. Closing the window asks in that same order, then shuts Forth down.

## Working directory

Forth starts in `Documents\EditForthWin`. `CHDIR` with a path changes that directory for the rest of the session. `FLOAD` and `INCLUDE` step into the loaded file's folder so a neighbor file can be loaded, then return to the directory from before that load. A nested load does the same. A `CHDIR` inside a loaded file is put back when that file finishes.

## Library

The shipped copies live in `Forth\Resources`: `Library`, `AutoLoad`, `Docs`, and `Config`. The first run copies `Library`, `AutoLoad`, and `Docs` into `Documents\EditForthWin` and creates an empty `Config` folder. Files already present are left as they are. The copy looks for `Forth\Resources\Library\BigInteger\big-int.fth` by walking up from the Forth executable.

`FROMLIB` and `FROM-LIBRARY` make the next relative load or `EDIT` start in `Documents\EditForthWin\Library`, then clear. `FROMLIB?` is true while that arm is set, and asking does not clear it. `FROMLIB-OFF` clears it without loading. `LIBRARY-PATH` returns that absolute Library directory. An absolute path is left unchanged. The PI demo is:

```
FROMLIB FLOAD PI/pi-test.fth
```

## Included lines

`FILE-ECHO` is a variable and starts off. `FILE-ECHO ON` prints each line of an `INCLUDE` or `FLOAD` before that line runs. The prefix is a five-digit line number, a bar, and a space.

`HERE` and `CELLS` are the colon words in `kernel1.fth`: `HERE` is `DP @`, and `CELLS` multiplies by 8. `CLS` is the colon word in `app-output.fth`. It clears the graphics character grid. The assembly originals are in the boot catalog and are replaced when those files load. The assembly `CLS` clears the Forth console window.

## Big integers

`BI-MUL`, `BI-DIVMOD`, and `BI-ISQRT` are kernel words. They use the `big-int.fth` layout: base `1000000000` limbs, then capacity, length, sign, and the limbs. `ALSO BIG-INTEGER` brings in the rest of that word set after the library file loads. A boot check of multiply, divide, and square root prints only when it fails.

## Graphics

`ALSO GRAPHICS` then `WINDOW` opens a character window. `CLS`, `AT`, `EMIT`, `TYPE`, and `."` draw into that window. `KEY` and `KEY?` read its keys. Arrow keys arrive as 200, 205, 208, and 203. `G-MOUSE` returns plot coordinates, origin at the bottom left, with buttons 1, 2, and 4. `TONE` takes a frequency in hertz and a duration in tenths of a second.

`1BIT`, `COLOR8`, and `TRUECOLOR` select the pixel map. `PLOT`, `LINE`, and `PREFRESH` send it to the same window. A finished resize is reported by `(APP-SIZE?)`.

`(APP-IMG-LOAD)` reads a BMP, PNG, JPEG, GIF, or TIFF. `(APP-IMG-SIZE)` and `(APP-IMG-RENDER)` use that image. `(APP-IMG-CHOOSE)`, `(APP-FILE-CHOOSE)`, and `(APP-FILE-SAVE-AS)` stage a path. `(APP-FILE-PATH)`, `(APP-FILE-SLURP)`, and `(APP-FILE-SPEW)` use the staged path. Under `--agent` those three dialogs return -1 and do not open a panel. The graphics window itself still opens.

`(OOP-CALL)` is the separate window, menu, and button host used by the class library. It is not the GRAPHICS window.

## Debugger

`DBG-ON` arms the stepper. At the prompt the return stack is already at the debug floor, so that line does not wait. A colon word called while the stepper is armed pauses on the first step inside that word and waits for a key. `DBG-OFF` prints `DEBUG done` and disarms it.

While paused, Space or `o` steps over, `i` steps into, `u` steps out, `g` runs, `q` or Esc aborts, and `h` shows the key line. The tagged keys are F6, F7, and F8 when a host sends them as `(2<<24)|16`, `|17`, and `|18`. The console key hook delivers characters.

`BREAK-TABLE` holds eight xt slots. `BREAK-ENABLES` is the matching flag table, 64 bytes later. `(BP-GO)` runs until an enabled slot matches. `(RUNTO-IP)` pauses at one threaded cell.

`VIEW-REG` records a source path and returns an id. `VIEW-PATH` returns that path. `VIEW-STAMP` stores a file id and line in the word header.

The other `DBG-*` hooks live in `SYSVOC`. `DBG-HOST-SPAN` remembers an editor span. A pause sends that span, the word name, and the stamped source path to the editor. A clean buffer highlights the span. A buffer with unsaved edits highlights the word name instead.

`Documents\EditForthWin\AutoLoad\autoload.fth` loads the debugger, the Emitter, and Hyper after boot. `--no-autoload` skips the file. The editor reads step keys as `32` (over), `105` (into), `33554450` (out, tagged F8), `103` (continue), and `113` (stop). F6, F7, F8, F5, and Esc send those keys while a pause is showing. Ctrl+Shift+Y asks Forth to pause at the next safe word. F9 toggles a breakpoint on the word at the caret. Arm runs `BPGO` on that word, or continues to the next enabled breakpoint when already paused.

## Facility terminal

`PAGE` clears an 88 by 27 character grid and homes the cursor. `AT-XY` moves that cursor. Column and row are 0-based. `AT-XY?` returns the column under the row. While the grid is active, `EMIT` paints cells there instead of the console. `TERMINAL-REFRESH` writes the grid to the console. `FACILITY-OFF` sends later output back to the console. `FACILITY-REV` turns reverse video on or off for the next cells. `(FACILITY-SIZE)` sets the grid, at least 16 by 8 and at most 256 by 128.

`CLIP!` and `CLIP@` copy text through the Windows clipboard. The assembly `CLS` still clears the console transcript. The `CLS` you type is the GRAPHICS word.

`FACILITY` and `FACILITY-EXT` still report false. `EKEY` is in the kernel. `EKEY>CHAR`, `EKEY>FKEY`, and the `K-` names come from the cold load.

## Validation

`FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth` was run after the normal boot on Oct 16, 2026.

Core, Core Ext, Search-Order, String, Facility, Exception, Memory-Allocation, Double, Locals, Programming-Tools, and File-Access finished with an empty stack and no failures. `123.` is a double literal. `LOCALS|` compiles its locals.

Block then stopped that run. It printed `BL-T ?` and `FAIL: LOAD`, then `BLK ?`, and the process faulted. XChar, Float, and Host did not run. There is no final pass count. That suite has not been run again. `LOAD`, `THRU`, and `BLK` have since been checked with a small script on both architectures.

The assembly words still open are listed in `REMAINING.md`.

## Later

`ALLOCATE-EXEC`, `FREE-EXEC`, `MPROTECT`, `ICACHE-INVAL`, `CALL-NATIVE`, `CALL-NATIVE-LEAF`, `NATIVE-SMOKE`, `JIT-WPROTECT`, `DOCON-ADDR`, and `(DOCON)` are in the kernel. On ARM64, `CALL-NATIVE` runs the buffer with the argument in x0 and the data stack in x19. On x64 the same word calls host machine code. The x64 console matches the ARM64 word set. `FILE-EXT`, `FLOATING`, and `BLOCK` report true. `FACILITY` and `FACILITY-EXT` report false. Emitter and Hyper stay commented out of autoload.
