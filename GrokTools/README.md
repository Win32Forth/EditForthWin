# GrokTools

Tools that ship with EditForthWin so a clone can rebuild the x64 kernel.

## arm64_to_ml64.py

Reads `Forth\kernel\arm64` and writes ml64 to `Forth\kernel\x64\asm`.
Those generated files are part of this repository. The ARM64 sources stay
the kernel text. This script is how the x64 translation is produced.
`build-x64.bat` runs it, then assembles the ml64 it just wrote.

The x64 image keeps one memory cell for each ARM64 register (`arm_x0`
through `arm_x30` in `Forth\kernel\x64\vmregs.asm`). Real RSP is the ARM
stack pointer. Calls between assembly words use a virtual link register.
Calls into the C host use the Windows x64 ABI.

`Forth\kernel\x64\identity.asm` is hand-written and is not produced here.
It holds the x64 version, the build date, and the console window title.

From the EditForthWin directory:

```
python GrokTools\arm64_to_ml64.py
```

Set `EDITFORTHWIN` if the kernel tree is not the directory you expect.
The script's default tree is `C:\VSCodeProjects\EditForthWin`.
