@echo off
setlocal
call "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" arm64_x64
if errorlevel 1 exit /b 1
cd /d "%~dp0"
set "PY=python"
if exist "%LOCALAPPDATA%\Programs\Python\Python313-arm64\python.exe" set "PY=%LOCALAPPDATA%\Programs\Python\Python313-arm64\python.exe"
"%PY%" "%~dp0GrokTools\arm64_to_ml64.py"
if errorlevel 1 exit /b 1
if not exist Forth\build\x64 mkdir Forth\build\x64
ml64 /nologo /c /Fo Forth\build\x64\state.obj Forth\kernel\x64\asm\state.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\emit.obj Forth\kernel\x64\asm\emit.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\boot_begin.obj Forth\kernel\x64\asm\boot_begin.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\prims.obj Forth\kernel\x64\asm\prims.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\prims_k1.obj Forth\kernel\x64\asm\prims_k1.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\prims_k2.obj Forth\kernel\x64\asm\prims_k2.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\prims_k3.obj Forth\kernel\x64\asm\prims_k3.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\sa_print.obj Forth\kernel\x64\asm\sa_print.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\sa_files.obj Forth\kernel\x64\asm\sa_files.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\sa_float.obj Forth\kernel\x64\asm\sa_float.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\prims_dbg.obj Forth\kernel\x64\asm\prims_dbg.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\dict.obj Forth\kernel\x64\asm\dict.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\entry.obj Forth\kernel\x64\asm\entry.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\cold.obj Forth\kernel\x64\asm\cold.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\vmregs.obj Forth\kernel\x64\vmregs.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\find_host.obj Forth\kernel\x64\find_host.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\identity.obj Forth\kernel\x64\identity.asm
if errorlevel 1 exit /b 1
ml64 /nologo /c /Fo Forth\build\x64\boot_end.obj Forth\kernel\x64\asm\boot_end.asm
if errorlevel 1 exit /b 1
cl /nologo /W3 /std:c11 /I Forth\include /Fe:Forth\build\x64\forthx64.exe /Fo:Forth\build\x64\ Forth\host\main.c Forth\host\console_win.c Forth\host\companion.c Forth\host\bigint.c Forth\host\gfx_win.c Forth\host\debug_win.c Forth\host\facility_win.c Forth\host\float_win.c Forth\host\exec_win.c Forth\build\x64\state.obj Forth\build\x64\emit.obj Forth\build\x64\boot_begin.obj Forth\build\x64\prims.obj Forth\build\x64\prims_k1.obj Forth\build\x64\prims_k2.obj Forth\build\x64\prims_k3.obj Forth\build\x64\sa_print.obj Forth\build\x64\sa_files.obj Forth\build\x64\sa_float.obj Forth\build\x64\prims_dbg.obj Forth\build\x64\dict.obj Forth\build\x64\entry.obj Forth\build\x64\cold.obj Forth\build\x64\vmregs.obj Forth\build\x64\find_host.obj Forth\build\x64\identity.obj Forth\build\x64\boot_end.obj /link /SUBSYSTEM:WINDOWS user32.lib gdi32.lib shell32.lib comdlg32.lib windowscodecs.lib ole32.lib
if errorlevel 1 exit /b 1
if not exist Forth\Resources\Library\Sources\x64 mkdir Forth\Resources\Library\Sources\x64
copy /Y Forth\kernel\x64\asm\*.asm Forth\Resources\Library\Sources\x64\ >nul
if errorlevel 1 exit /b 1
copy /Y Forth\kernel\x64\identity.asm Forth\Resources\Library\Sources\x64\ >nul
if errorlevel 1 exit /b 1
copy /Y Forth\kernel\x64\vmregs.asm Forth\Resources\Library\Sources\x64\ >nul
if errorlevel 1 exit /b 1
copy /Y Forth\kernel\x64\find_host.asm Forth\Resources\Library\Sources\x64\ >nul
if errorlevel 1 exit /b 1
echo Copied ml64 sources to Forth\Resources\Library\Sources\x64
if exist "%USERPROFILE%\Documents\EditForthWin\Library\Sources" (
  if not exist "%USERPROFILE%\Documents\EditForthWin\Library\Sources\x64" mkdir "%USERPROFILE%\Documents\EditForthWin\Library\Sources\x64"
  copy /Y Forth\kernel\x64\asm\*.asm "%USERPROFILE%\Documents\EditForthWin\Library\Sources\x64\" >nul
  copy /Y Forth\kernel\x64\identity.asm "%USERPROFILE%\Documents\EditForthWin\Library\Sources\x64\" >nul
  copy /Y Forth\kernel\x64\vmregs.asm "%USERPROFILE%\Documents\EditForthWin\Library\Sources\x64\" >nul
  copy /Y Forth\kernel\x64\find_host.asm "%USERPROFILE%\Documents\EditForthWin\Library\Sources\x64\" >nul
  echo Copied ml64 sources to Documents\EditForthWin\Library\Sources\x64
)

set QTDIR=C:\Qt\6.11.3\msvc2022_64
set CMAKE=C:\Qt\Tools\cmake-4.4.4-windows-arm64\bin\cmake.exe
if not exist "%QTDIR%\lib\cmake\Qt6\Qt6Config.cmake" (
  echo Qt 6.11.3 for x64 is not installed at %QTDIR%
  exit /b 1
)
if not exist "%CMAKE%" (
  echo CMake is not installed at %CMAKE%
  exit /b 1
)
if not exist Edit\build\x64 mkdir Edit\build\x64
"%CMAKE%" -S Edit -B Edit\build\x64 -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="%QTDIR%" -DEDITFORTH_ARCH=x64
if errorlevel 1 exit /b 1
"%CMAKE%" --build Edit\build\x64
if errorlevel 1 exit /b 1
"%QTDIR%\bin\windeployqt.exe" --release --no-translations Edit\build\x64\editforthwinx64.exe
if errorlevel 1 exit /b 1
exit /b 0
