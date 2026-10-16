# EditForthWin

Windows sibling of [EditForth](https://github.com/Win32Forth/EditForth). This tree holds the Forth console and the Qt editor.

**Version 1.1.0**, released Oct 15, 2026 6:05 PM.

Starting `forth.exe` opens a window. The cold-load lines appear, then the banner, then a prompt:

```
=== EditForthWin 1.1.0 === Oct 15, 2026 6:05 PM ===
ok(0)>
```

The banner matches the Mac EditForth console. The version and the release date and time are fixed in `Forth\host\main.c` and change when the version changes. Return evaluates the line at the prompt. Up and Down recall earlier lines. `BYE` closes the window.

`--agent` runs the same kernel with no window and writes the transcript to the console that launched it:

```bat
forth.exe --agent -e "2 3 + ."
forth.exe --agent --help
```

## Layout

`Forth` is the interpreter. `Edit` is the Qt editor. `build.bat` at the project root builds both. Forth objects and `forth.exe` go in `Forth\build\arm64\`. The editor executable is `Edit\build\arm64\editforthwin.exe`.

The ARM64 kernel under `Forth\kernel\arm64` is indirect-threaded code with TOS in `x20`, the same register map as the Mac kernel. `NEXT` loads a code field and jumps to it. Assembly words use `BOOT_WORD` rows and the Mac header: counted help, counted name, link, flags, code field. `Forth\host\main.c` is the C host. Windows calls stay there. `Forth\include\kernel_api.h` exposes `kernel_init`, `kernel_eval`, `kernel_set_emit`, and `kernel_set_key`.

Cold start interprets one blob of `kernel1.fth`, `kernel2.fth`, `vocemit.fth`, `app-output.fth`, `app-points.fth`, `vocsys.fth`, and `xref.fth`. Other files load with `INCLUDE`. The x64 kernel is the same ITC design and is not started.

## Build

From this directory:

```bat
build.bat
```

The executables are `Forth\build\arm64\forth.exe` and `Edit\build\arm64\editforthwin.exe`. The editor build uses Qt 6.11.3 at `C:\Qt\6.11.3\msvc2022_arm64` and CMake at `C:\Qt\Tools\cmake-4.4.4-windows-arm64`. In VS Code, Ctrl+Shift+B builds both. F5 builds and opens the Forth window. Close a running `forth.exe` before rebuilding, or the linker cannot replace it.

## Editor

The editor opens one window with a tab per file, Consolas, line numbers, and New, Open, Save, and Save As. A Forth pane under the tabs launches `forth.exe --companion` and shows the cold-load lines, the banner, and `ok(n)>`. Return in that pane runs the line. Above that pane, the status strip shows whether Forth is connected and, while the stepper is armed, the paused word. The debug bar under it steps, continues, and stops. Letter keys stay in the editor. Undock moves that same console into a window titled Forth. Dock puts it back. Closing the Forth window hides the transcript and leaves the engine running. Unhide Forth shows it again. The choice is remembered.

Bare `EDIT` opens a file into a tab. `EDIT` with a name opens that file, and `FROMLIB EDIT sample\clock.fth` opens the copy under `Documents\EditForthWin\Library`. Quotes around the name are optional. `FROMLIB` does not change the Forth directory. Bare `FLOAD` or `INCLUDE` loads the file you pick. Those dialogs, and File > Open, list `.fth`, `.fs`, `.4th`, `.f`, and `.txt`. They start in the current Forth directory, and you can navigate from there. A path that contains a quote, or is longer than 255 characters, is not loaded.

`BYE` in the Forth pane closes the editor. Unsaved files are asked about first. Cancel leaves both the editor and Forth running. Closing the window asks in that same order, then shuts Forth down.

## Working directory

Forth starts in `Documents\EditForthWin`. `CHDIR` with a path changes that directory for the rest of the session. `FLOAD` and `INCLUDE` step into the loaded file's folder so a neighbor file can be loaded, then return to the directory from before that load. A nested load does the same. A `CHDIR` inside a loaded file is put back when that file finishes.

## Library

The shipped copies live in `Forth\Resources`: `Library`, `AutoLoad`, `Docs`, and `Config`. The first run copies `Library`, `AutoLoad`, and `Docs` into `Documents\EditForthWin` and creates an empty `Config` folder. Files already present are left as they are. The copy looks for `Forth\Resources\Library\BigInteger\big-int.fth` by walking up from `forth.exe`.

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

`Documents\EditForthWin\AutoLoad\autoload.fth` loads the debugger after boot. Emitter and Hyper in that file are commented out so boot can reach the debugger. Restore those lines when those loads should run on Windows again. `--no-autoload` skips the file. The editor reads step keys as `32` (over), `105` (into), `33554450` (out, tagged F8), `103` (continue), and `113` (stop). F6, F7, F8, F5, and Esc send those keys while a pause is showing. Ctrl+Shift+Y asks Forth to pause at the next safe word. F9 toggles a breakpoint on the word at the caret. Arm runs `BPGO` on that word, or continues to the next enabled breakpoint when already paused.

## Facility terminal

`PAGE` clears an 88 by 27 character grid and homes the cursor. `AT-XY` moves that cursor. Column and row are 0-based. `AT-XY?` returns the column under the row. While the grid is active, `EMIT` paints cells there instead of the console. `TERMINAL-REFRESH` writes the grid to the console. `FACILITY-OFF` sends later output back to the console. `FACILITY-REV` turns reverse video on or off for the next cells. `(FACILITY-SIZE)` sets the grid, at least 16 by 8 and at most 256 by 128.

`CLIP!` and `CLIP@` copy text through the Windows clipboard. The assembly `CLS` still clears the console transcript. The `CLS` you type is the GRAPHICS word.

`FACILITY` and `FACILITY-EXT` still report false. `EKEY` is in the kernel. `EKEY>CHAR`, `EKEY>FKEY`, and the `K-` names come from the cold load.

## Validation

`FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth` was run after the normal boot on Oct 16, 2026.

Core, Core Ext, Search-Order, String, Facility, Exception, and Memory-Allocation finished with an empty stack and no failures.

Double failed one check. `123.` is not accepted as a double literal, so the suite printed `123. ?` and `FAIL: lit.`. The rest of that section finished.

Locals then stopped the run. `(LOCAL)` does not compile a local, so `LOCALS|` leaves the name unknown and the following `TO` aborts the load. Tools, File, Block, XChar, Float, and Host did not run. There is no final pass count.

## Later

The x64 kernel and native code are not in this editor yet. `FILE-EXT` reports true. `FACILITY`, `FLOATING`, and `BLOCK` report false. Trailing-dot double literals and `(LOCAL)` are the open ANS-VALIDATE gaps above. Emitter and Hyper stay commented out of autoload.
