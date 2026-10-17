Library/Sources — shipped kernel source for VIEW / Hyper
========================================================

High-level kernel sources (kernel1.fth, kernel2.fth, and the other cold
files) stay in this folder.

Windows assembly is not forth.s. forth.s is the Mac kernel. Each Forth
build copies the assembler sources for that image:

  Library/Sources/arm64/     armasm64 sources (Forth/kernel/arm64)
  Library/Sources/x64/       ml64 sources (Forth/kernel/x64)

The first launch copies files that are not already under
Documents\EditForthWin\Library. HYPER-REINDEX reads the folder that
matches the running program. VIEW of DUP opens prims.asm in that folder.

Do not edit the copies here. Edit Forth/kernel, rebuild, and reindex.
