@echo off
setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" arm64
if errorlevel 1 exit /b 1
cd /d "%~dp0"
if not exist Forth\build\arm64 mkdir Forth\build\arm64
armasm64 -nologo -o Forth\build\arm64\state.obj Forth\kernel\arm64\state.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\emit.obj Forth\kernel\arm64\emit.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\boot_begin.obj Forth\kernel\arm64\boot_begin.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\prims.obj Forth\kernel\arm64\prims.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\prims_k1.obj Forth\kernel\arm64\prims_k1.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\prims_k2.obj Forth\kernel\arm64\prims_k2.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\prims_k3.obj Forth\kernel\arm64\prims_k3.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\prims_dbg.obj Forth\kernel\arm64\prims_dbg.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\dict.obj Forth\kernel\arm64\dict.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\entry.obj Forth\kernel\arm64\entry.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\cold.obj Forth\kernel\arm64\cold.asm
if errorlevel 1 exit /b 1
armasm64 -nologo -o Forth\build\arm64\boot_end.obj Forth\kernel\arm64\boot_end.asm
if errorlevel 1 exit /b 1
cl /nologo /W3 /std:c11 /I Forth\include /Fe:Forth\build\arm64\forth.exe /Fo:Forth\build\arm64\ Forth\host\main.c Forth\host\console_win.c Forth\host\companion.c Forth\host\bigint.c Forth\host\gfx_win.c Forth\host\debug_win.c Forth\build\arm64\state.obj Forth\build\arm64\emit.obj Forth\build\arm64\boot_begin.obj Forth\build\arm64\prims.obj Forth\build\arm64\prims_k1.obj Forth\build\arm64\prims_k2.obj Forth\build\arm64\prims_k3.obj Forth\build\arm64\prims_dbg.obj Forth\build\arm64\dict.obj Forth\build\arm64\entry.obj Forth\build\arm64\cold.obj Forth\build\arm64\boot_end.obj /link /SUBSYSTEM:WINDOWS user32.lib gdi32.lib shell32.lib comdlg32.lib windowscodecs.lib ole32.lib
if errorlevel 1 exit /b 1

set QTDIR=C:\Qt\6.11.3\msvc2022_arm64
set CMAKE=C:\Qt\Tools\cmake-4.4.4-windows-arm64\bin\cmake.exe
if not exist "%QTDIR%\lib\cmake\Qt6\Qt6Config.cmake" (
  echo Qt 6.11.3 for ARM64 is not installed at %QTDIR%
  exit /b 1
)
if not exist "%CMAKE%" (
  echo CMake is not installed at %CMAKE%
  exit /b 1
)
if not exist Edit\build\arm64 mkdir Edit\build\arm64
"%CMAKE%" -S Edit -B Edit\build\arm64 -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="%QTDIR%"
if errorlevel 1 exit /b 1
"%CMAKE%" --build Edit\build\arm64
if errorlevel 1 exit /b 1
"%QTDIR%\bin\windeployqt.exe" --release --no-translations Edit\build\arm64\editforthwin.exe
if errorlevel 1 exit /b 1
exit /b 0
