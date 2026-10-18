@echo off
setlocal
cd /d "%~dp0.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0stage.ps1"
if errorlevel 1 exit /b 1
set ISCC=%LOCALAPPDATA%\Programs\Inno Setup 6\ISCC.exe
if not exist "%ISCC%" set ISCC=%ProgramFiles(x86)%\Inno Setup 6\ISCC.exe
if not exist "%ISCC%" (
  echo Inno Setup 6 ISCC.exe was not found.
  exit /b 1
)
"%ISCC%" /DArch=arm64 "%~dp0EditForthWin.iss"
if errorlevel 1 exit /b 1
"%ISCC%" /DArch=x64 "%~dp0EditForthWin.iss"
if errorlevel 1 exit /b 1
echo Installers are in dist\
exit /b 0