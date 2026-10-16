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

The editor opens one window with a tab per file, Consolas, line numbers, and New, Open, Save, and Save As. A Forth pane under the tabs launches `forth.exe --companion` and shows the cold-load lines, the banner, and `ok(n)>`. Return in that pane runs the line.

Bare `EDIT` opens a file into a tab. Bare `FLOAD` or `INCLUDE` loads the file you pick. Those dialogs, and File > Open, list `.fth`, `.fs`, `.4th`, `.f`, and `.txt`. They start in the current Forth directory, and you can navigate from there. A path that contains a quote, or is longer than 255 characters, is not loaded.

`BYE` in the Forth pane closes the editor. Unsaved files are asked about first. Cancel leaves both the editor and Forth running. Closing the window asks in that same order, then shuts Forth down.

## Working directory

Forth starts in `Documents\EditForthWin`. `CHDIR` with a path changes that directory for the rest of the session. `FLOAD` and `INCLUDE` step into the loaded file's folder so a neighbor file can be loaded, then return to the directory from before that load. A nested load does the same. A `CHDIR` inside a loaded file is put back when that file finishes.

## Library

The first run copies `Library`, `AutoLoad`, and `Docs` into `Documents\EditForthWin` and creates an empty `Config` folder. Files already present are left as they are. The copy looks for a library that contains `BigInteger\big-int.fth`, walking up from `forth.exe` through `Forth\Resources\Library`, `Resources\Library`, and `EditForth\Forth\Resources\Library`.

`FROMLIB` and `FROM-LIBRARY` make the next relative load start in `Documents\EditForthWin\Library`, then clear. `FROMLIB-OFF` clears that without loading. An absolute path is left unchanged. The PI demo is:

```
FROMLIB FLOAD PI/pi-test.fth
```

## Big integers

`BI-MUL`, `BI-DIVMOD`, and `BI-ISQRT` are kernel words. They use the `big-int.fth` layout: base `1000000000` limbs, then capacity, length, sign, and the limbs. `ALSO BIG-INTEGER` brings in the rest of that word set after the library file loads. A boot check of multiply, divide, and square root prints only when it fails.

## Later

The x64 kernel, the debugger, the facility screen, graphics windows, and native code are not in this editor yet. `FILE-EXT` reports true. `FACILITY`, `FLOATING`, and `BLOCK` report false.
