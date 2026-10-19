; EditForthWin per-user installer. One build for ARM64, one for x64.
; iscc /DArch=arm64 Install\EditForthWin.iss
; iscc /DArch=x64 Install\EditForthWin.iss

#ifndef Arch
  #define Arch "arm64"
#endif

#if Arch == "x64"
  #define AppArch "x64"
  #define ArchTag "x64"
  #define ForthExe "forthx64.exe"
  #define EditExe "editforthwinx64.exe"
  #define ArchAllowed "x64compatible"
  #define AppGuid "{{C2D9E8F1-4A76-4B03-8E55-7C19D0AB2468}"
#else
  #define AppArch "ARM64"
  #define ArchTag "arm64"
  #define ForthExe "fortharm64.exe"
  #define EditExe "editforthwinarm64.exe"
  #define ArchAllowed "arm64"
  #define AppGuid "{{E4F7A1B2-6C30-4D85-9A17-3B8E2F01A641}"
#endif

#define AppVersion "1.2.7"

[Setup]
AppId={#AppGuid}
AppName=EditForthWin {#AppArch}
AppVersion={#AppVersion}
AppVerName=EditForthWin {#AppVersion} {#AppArch}
AppPublisher=Win32Forth
AppComments=EditForthWin {#AppArch}. Public domain.
DefaultDirName={localappdata}\Programs\EditForthWin-{#AppArch}
DefaultGroupName=EditForthWin
DisableProgramGroupPage=yes
OutputDir=..\dist
OutputBaseFilename=EditForthWin-{#AppVersion}-{#ArchTag}
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed={#ArchAllowed}
ArchitecturesInstallIn64BitMode={#ArchAllowed}
PrivilegesRequired=lowest
UninstallDisplayName=EditForthWin {#AppVersion} {#AppArch}
WizardStyle=modern
CloseApplications=yes
RestartApplications=no

[Files]
Source: "stage\{#ArchTag}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\Forth\Resources\*"; DestDir: "{app}\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "install-docs.ps1"; DestDir: "{app}"; Flags: ignoreversion

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Icons]
Name: "{autoprograms}\EditForthWin {#AppArch}"; Filename: "{app}\{#EditExe}"
Name: "{autoprograms}\EditForthWin {#AppArch} Console"; Filename: "{app}\{#ForthExe}"
Name: "{autodesktop}\EditForthWin {#AppArch}"; Filename: "{app}\{#EditExe}"; Tasks: desktopicon

[Run]
Filename: "powershell.exe"; \
  Parameters: "-NoProfile -ExecutionPolicy Bypass -File ""{app}\install-docs.ps1"""; \
  StatusMsg: "Copying Resources into Documents\EditForthWin..."; \
  Flags: runhidden waituntilterminated

[Messages]
FinishedLabel=EditForthWin {#AppArch} is installed. Library, AutoLoad, Docs, and Config are in Documents\EditForthWin. Files that were already there were left as they are. Uninstall removes this program and does not remove that folder.
