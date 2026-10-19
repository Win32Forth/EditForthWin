# EditForthWin release helper.
# Adapted from EditForth scripts/release.sh for the Windows ARM64 and x64 builds.
# Public domain.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 bump 1.2.8
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 build
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 build-arm64
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 build-x64
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 installers
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 banners
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 validate
#   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\release.ps1 prep 1.2.8 --stamp "Oct 19, 2026 10:29 AM"
#
# bump updates both kernel identity files, the installer version, the current
# README and REMAINING stamps, and the dist gitignore exceptions.
# It does not rewrite older version paragraphs.
# build runs build.bat and build-x64.bat in separate cmd processes.
# validate runs ANS-VALIDATE and Hayes on both forth executables, with autoload.
# Does not delete old installers, commit, push, or create a GitHub release.

param(
    [Parameter(Position = 0)]
    [string]$Command = 'help',
    [Parameter(Position = 1)]
    [string]$Version = '',
    [string]$Stamp = '',
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Rest = @()
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\release-common.ps1')

function Show-ReleaseUsage {
    @'
EditForthWin release helper (ARM64 and x64)

  bump <ver> [--stamp "..."]   Stamp both kernels, the installer, and current docs
  build-arm64                  build.bat
  build-x64                    build-x64.bat
  build                        Both architectures, ARM64 then x64
  installers                   Install\build-installers.bat (both installers)
  banners                      Check both forth executables against identity.asm
  validate                     ANS-VALIDATE and Hayes on ARM64, then x64
  prep <ver> [--stamp "..."]   bump, build, banners, validate, installers

  --skip-validate              prep: skip ANS-VALIDATE and Hayes

Does NOT delete old dist installers, commit, push, or create GitHub releases.
'@
}

function Invoke-Bump {
    if (-not $Version) { Stop-Release 'usage: bump <version> [--stamp "..."]' }
    if ($Version -notmatch '^\d+\.\d+\.\d+$') { Stop-Release "version must look like 1.2.8: $Version" }
    if (-not $Stamp) { $Stamp = Get-Date -Format 'MMM d, yyyy h:mm tt' }
    $old = Read-AppVersion
    Write-Note "bump $old -> $Version"
    Write-Note "stamp: $Stamp"
    Set-IdentityStamp 'arm64' $Version $Stamp
    Set-IdentityStamp 'x64' "$Version-x64" $Stamp
    $iss = Join-Path $Script:ReleaseRoot 'Install\EditForthWin.iss'
    $issText = Read-ReleaseText $iss
    $issNext = [regex]::Replace($issText, '#define AppVersion "[^"]+"', ('#define AppVersion "' + $Version + '"'))
    if ($issNext -eq $issText -and $issText -notlike ('*#define AppVersion "' + $Version + '"*')) {
        Stop-Release 'AppVersion was not updated'
    }
    if ($issNext -ne $issText) { Write-ReleaseText $iss $issNext }
    Update-CurrentDocs $Version $Stamp
    Set-GitIgnoreInstallers $Version
    Write-Ok "bumped to $Version"
    Write-Note 'Console titles were left as EditForthWin Arm64 and EditForthWin x64.'
    Write-Note 'Add the version paragraph in README.md and REMAINING.md by hand.'
}

switch ($Command) {
    'help' { Show-ReleaseUsage }
    'bump' { Invoke-Bump }
    'build-arm64' { Invoke-ReleaseCmd 'build.bat' 'build-arm64.txt' | Out-Null; Write-Ok 'ARM64 build' }
    'build-x64' { Invoke-ReleaseCmd 'build-x64.bat' 'build-x64.txt' | Out-Null; Write-Ok 'x64 build' }
    'build' {
        Invoke-ReleaseCmd 'build.bat' 'build-arm64.txt' | Out-Null
        Invoke-ReleaseCmd 'build-x64.bat' 'build-x64.txt' | Out-Null
        Write-Ok 'both builds'
    }
    'installers' { Invoke-ReleaseCmd 'Install\build-installers.bat' 'installers.txt' | Out-Null; Write-Ok 'installers' }
    'banners' {
        Invoke-BannerCheck 'arm64'
        Invoke-BannerCheck 'x64'
    }
    'validate' { Invoke-Validate }
    'prep' {
        Invoke-Bump
        Invoke-ReleaseCmd 'build.bat' 'build-arm64.txt' | Out-Null
        Invoke-ReleaseCmd 'build-x64.bat' 'build-x64.txt' | Out-Null
        Invoke-BannerCheck 'arm64'
        Invoke-BannerCheck 'x64'
        if ($Rest -contains '--skip-validate') { Write-Note 'skipping validate' }
        else { Invoke-Validate }
        Invoke-ReleaseCmd 'Install\build-installers.bat' 'installers.txt' | Out-Null
        Show-ReleaseHandoff
    }
    default { Stop-Release "unknown command: $Command" }
}
