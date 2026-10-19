# Shared helpers for EditForthWin scripts\release.ps1
# Adapted from EditForth scripts/lib/release-common.sh.
# Public domain.

$ErrorActionPreference = 'Stop'

$Script:ReleaseRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$Script:LogDir = Join-Path $env:TEMP 'editforthwin-release'
New-Item -ItemType Directory -Force -Path $Script:LogDir | Out-Null

function Write-Note([string]$Message) { Write-Output $Message }
function Write-Ok([string]$Message) { Write-Output "OK  $Message" }
function Stop-Release([string]$Message) { throw $Message }

function Read-ReleaseText([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) { Stop-Release "missing $Path" }
    return [System.IO.File]::ReadAllText($Path)
}

function Write-ReleaseText([string]$Path, [string]$Text) {
    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($Path, $Text, $utf8)
}

function Update-ReleaseText([string]$Path, [scriptblock]$Edit) {
    $old = Read-ReleaseText $Path
    $new = & $Edit $old
    if ($new -eq $old) { Stop-Release "no change in $Path" }
    Write-ReleaseText $Path $new
}

function Get-ReleaseNewline([string]$Text) {
    if ($Text.Contains("`r`n")) { return "`r`n" }
    return "`n"
}

function Read-AppVersion {
    $iss = Read-ReleaseText (Join-Path $Script:ReleaseRoot 'Install\EditForthWin.iss')
    $m = [regex]::Match($iss, '#define AppVersion "([^"]+)"')
    if (-not $m.Success) { Stop-Release 'cannot read AppVersion' }
    return $m.Groups[1].Value
}

function Read-IdentityStamp([string]$Arch) {
    $rel = if ($Arch -eq 'arm64') { 'Forth\kernel\arm64\identity.asm' } else { 'Forth\kernel\x64\identity.asm' }
    $text = Read-ReleaseText (Join-Path $Script:ReleaseRoot $rel)
    $ver = [regex]::Match($text, 'kernel_version\s+\S+\s+"([^"]+)"')
    $built = [regex]::Match($text, 'kernel_built\s+\S+\s+"([^"]+)"')
    if (-not $ver.Success -or -not $built.Success) { Stop-Release "cannot read $rel" }
    return @{ Version = $ver.Groups[1].Value; Built = $built.Groups[1].Value }
}

function Replace-Once([string]$Text, [string]$Pattern, [object]$Replacement) {
    $re = New-Object System.Text.RegularExpressions.Regex $Pattern
    return $re.Replace($Text, $Replacement, 1)
}

function Set-IdentityStamp([string]$Arch, [string]$Version, [string]$Stamp) {
    $rel = if ($Arch -eq 'arm64') { 'Forth\kernel\arm64\identity.asm' } else { 'Forth\kernel\x64\identity.asm' }
    $path = Join-Path $Script:ReleaseRoot $rel
    $text = Read-ReleaseText $path
    $text2 = Replace-Once $text 'kernel_version(\s+\S+\s+)"[^"]+"' ([System.Text.RegularExpressions.MatchEvaluator]{ param($m) 'kernel_version' + $m.Groups[1].Value + '"' + $Version + '"' })
    $text3 = Replace-Once $text2 'kernel_built(\s+\S+\s+)"[^"]+"' ([System.Text.RegularExpressions.MatchEvaluator]{ param($m) 'kernel_built' + $m.Groups[1].Value + '"' + $Stamp + '"' })
    if ($text3 -eq $text) {
        if ($text.Contains('"' + $Version + '"') -and $text.Contains('"' + $Stamp + '"')) { return }
        Stop-Release "identity unchanged: $rel"
    }
    if ($text3 -notlike "*`"$Version`"*") { Stop-Release "identity version was not written: $rel" }
    Write-ReleaseText $path $text3
}

function Set-GitIgnoreInstallers([string]$Version) {
    $path = Join-Path $Script:ReleaseRoot '.gitignore'
    $text = Read-ReleaseText $path
    $nl = Get-ReleaseNewline $text
    $stripped = [regex]::Replace($text, '(?m)^!dist/EditForthWin-.*(?:\r?\n)?', '')
    $block = 'dist/*' + $nl + '!dist/EditForthWin-' + $Version + '-arm64.exe' + $nl + '!dist/EditForthWin-' + $Version + '-x64.exe' + $nl
    $updated = Replace-Once $stripped '(?m)^dist/\*\r?\n' $block
    if ($updated -eq $text -and $text.Contains('EditForthWin-' + $Version + '-arm64.exe')) { return }
    if ($updated -notlike ('*!dist/EditForthWin-' + $Version + '-x64.exe*')) {
        Stop-Release 'gitignore installer exceptions were not written'
    }
    Write-ReleaseText $path $updated
}

function Update-OneLine([string]$Text, [string]$Pattern, [string]$Replacement) {
    $re = New-Object System.Text.RegularExpressions.Regex $Pattern
    if (-not $re.IsMatch($Text)) { Stop-Release "pattern did not match: $Pattern" }
    return $re.Replace($Text, $Replacement, 1)
}

function Update-CurrentDocs([string]$Version, [string]$Stamp) {
    $arm = $Version
    $x64 = $Version + '-x64'
    $readmePath = Join-Path $Script:ReleaseRoot 'README.md'
    $readme = Read-ReleaseText $readmePath
    $readme = Update-OneLine $readme '(?m)^\*\*Version .*' ('**Version ' + $arm + '** on ARM64 and **' + $x64 + '** on x64. ARM64 was built ' + $Stamp + '. x64 was built ' + $Stamp + '.')
    $readme = Update-OneLine $readme '=== EditForthWin [0-9.]+ === .* ===' ('=== EditForthWin ' + $arm + ' === ' + $Stamp + ' ===')
    $readme = Update-OneLine $readme 'identity\.asm` \(`[^`]+`, `[^`]+`, window title `EditForthWin Arm64`\)' ('identity.asm` (`' + $arm + '`, `' + $Stamp + '`, window title `EditForthWin Arm64`)')
    $readme = Update-OneLine $readme 'identity\.asm` \(`[^`]+`, `[^`]+`, window title `EditForthWin x64`\)' ('identity.asm` (`' + $x64 + '`, `' + $Stamp + '`, window title `EditForthWin x64`)')
    $readme = Update-OneLine $readme 'EditForthWin-[0-9.]+-arm64\.exe' ('EditForthWin-' + $arm + '-arm64.exe')
    $readme = Update-OneLine $readme 'EditForthWin-[0-9.]+-x64\.exe' ('EditForthWin-' + $arm + '-x64.exe')
    Write-ReleaseText $readmePath $readme

    $remainingPath = Join-Path $Script:ReleaseRoot 'REMAINING.md'
    $remaining = Read-ReleaseText $remainingPath
    $remaining = Update-OneLine $remaining '(?m)^Updated .*?\. x64 is `[^`]+`, built [^.]+\.' ('Updated ' + $Stamp + ' for version ' + $arm + '. ARM64 is `' + $arm + '`, built ' + $Stamp + '. x64 is `' + $x64 + '`, built ' + $Stamp + '.')
    Write-ReleaseText $remainingPath $remaining
}

function Invoke-ReleaseCmd([string]$Command, [string]$LogName) {
    $log = Join-Path $Script:LogDir $LogName
    Write-Note ('cmd: ' + $Command)
    $bat = Join-Path $Script:ReleaseRoot '_efw_release_cmd.bat'
    Set-Content -LiteralPath $bat -Encoding ASCII -Value ('@echo off' + "`r`n" + 'cd /d "' + $Script:ReleaseRoot + '"' + "`r`n" + 'call ' + $Command + "`r`n" + 'exit /b %ERRORLEVEL%' + "`r`n")
    cmd /c "`"$bat`" > `"$log`" 2>&1"
    $code = $LASTEXITCODE
    Remove-Item -LiteralPath $bat -Force -ErrorAction SilentlyContinue
    if ($code -ne 0) { Stop-Release ($Command + ' failed (' + $code + '). See ' + $log) }
    return $log
}

function Get-ForthExe([string]$Arch) {
    $rel = if ($Arch -eq 'arm64') { 'Forth\build\arm64\fortharm64.exe' } else { 'Forth\build\x64\forthx64.exe' }
    $path = Join-Path $Script:ReleaseRoot $rel
    if (-not (Test-Path -LiteralPath $path)) { Stop-Release "missing $path" }
    return $path
}

function Invoke-ForthAgent([string]$Arch, [string]$Eval, [string]$LogName) {
    $path = Get-ForthExe $Arch
    $log = Join-Path $Script:LogDir $LogName
    $bat = Join-Path $Script:ReleaseRoot '_efw_agent.bat'
    Write-Note ("agent " + $Arch + ": " + $Eval)
    Set-Content -LiteralPath $bat -Encoding ASCII -Value (
        '@echo off' + "`r`n" +
        'cd /d "' + $Script:ReleaseRoot + '"' + "`r`n" +
        '"' + $path + '" --agent -e "' + $Eval + '"' + "`r`n" +
        'exit /b %ERRORLEVEL%' + "`r`n")
    cmd /c "`"$bat`" > `"$log`" 2>&1"
    $code = $LASTEXITCODE
    Remove-Item -LiteralPath $bat -Force -ErrorAction SilentlyContinue
    return @{ Code = $code; Log = $log; Text = (Read-ReleaseText $log) }
}

function Assert-AgentOk($Result, [string]$Name) {
    if ($Result.Text.Contains('uncaught THROW')) { Stop-Release ($Name + ': uncaught THROW (see ' + $Result.Log + ')') }
    if ($Result.Text.Contains("can't open:")) { Stop-Release ($Name + ': can''t open: (see ' + $Result.Log + ')') }
    if ($Result.Text.Contains('DONE (failed)') -or $Result.Code -ne 0) {
        Stop-Release ($Name + ': agent failed (' + $Result.Code + ') (see ' + $Result.Log + ')')
    }
}

function Invoke-AnsValidate([string]$Arch) {
    $result = Invoke-ForthAgent $Arch 'FROMLIB FLOAD Testing/ANSValidate/ANS-VALIDATE.fth' ('ans-' + $Arch + '.txt')
    Assert-AgentOk $result ('ANS-VALIDATE ' + $Arch)
    if ($result.Text.IndexOf('=== ANS-VALIDATE driver done ===') -lt 0) {
        Stop-Release ('ANS-VALIDATE ' + $Arch + ': driver did not finish (see ' + $result.Log + ')')
    }
    if ($result.Text.IndexOf('ALL PASS') -lt 0) {
        Stop-Release ('ANS-VALIDATE ' + $Arch + ': missing ALL PASS (see ' + $result.Log + ')')
    }
    if ($result.Text -notmatch 'passed, 0 failed') {
        Stop-Release ('ANS-VALIDATE ' + $Arch + ': missing 0 failed (see ' + $result.Log + ')')
    }
    if ($result.Text.Contains('*** FAILURES ***')) {
        Stop-Release ('ANS-VALIDATE ' + $Arch + ': FAILURES (see ' + $result.Log + ')')
    }
    Write-Ok ('ANS-VALIDATE ' + $Arch)
}

function Invoke-Hayes([string]$Arch) {
    $result = Invoke-ForthAgent $Arch 'FROMLIB FLOAD Testing/HayesTest/HayesTest.fth' ('hayes-' + $Arch + '.txt')
    Assert-AgentOk $result ('Hayes ' + $Arch)
    if ($result.Text.IndexOf('=== 64Forth Hayes subset complete ===') -lt 0) {
        Stop-Release ('Hayes ' + $Arch + ': suite did not finish (see ' + $result.Log + ')')
    }
    if ($result.Text -match 'FAILURES DETECTED') {
        Stop-Release ('Hayes ' + $Arch + ': FAILURES DETECTED (see ' + $result.Log + ')')
    }
    if ($result.Text.IndexOf('ALL COUNTS ZERO') -lt 0) {
        Stop-Release ('Hayes ' + $Arch + ': missing ALL COUNTS ZERO (see ' + $result.Log + ')')
    }
    Write-Ok ('Hayes ' + $Arch)
}

function Invoke-Validate {
    foreach ($arch in @('arm64', 'x64')) {
        Invoke-AnsValidate $arch
        Invoke-Hayes $arch
    }
    Write-Ok 'validate complete'
}

function Invoke-BannerCheck([string]$Arch) {
    $id = Read-IdentityStamp $Arch
    $path = Get-ForthExe $Arch
    $log = Join-Path $Script:LogDir ('banner-' + $Arch + '.txt')
    $bat = Join-Path $Script:ReleaseRoot '_efw_banner.bat'
    Set-Content -LiteralPath $bat -Encoding ASCII -Value ('@echo off' + "`r`n" + 'cd /d "' + $Script:ReleaseRoot + '"' + "`r`n" + '"' + $path + '" --agent --no-autoload -e BYE' + "`r`n" + 'exit /b %ERRORLEVEL%' + "`r`n")
    cmd /c "`"$bat`" > `"$log`" 2>&1"
    Remove-Item -LiteralPath $bat -Force -ErrorAction SilentlyContinue
    $text = Read-ReleaseText $log
    $expect = '=== EditForthWin ' + $id.Version + ' === ' + $id.Built + ' ==='
    if ($text.IndexOf($expect) -lt 0) { Stop-Release ($Arch + ' banner is not ' + $expect + ' (see ' + $log + ')') }
    Write-Ok ($Arch + ' ' + $expect)
}

function Show-ReleaseHandoff {
    $ver = Read-AppVersion
    Write-Output ''
    Write-Output '======== handoff ========'
    Write-Output ('Installers: dist\EditForthWin-' + $ver + '-arm64.exe and dist\EditForthWin-' + $ver + '-x64.exe')
    Write-Output 'Next (human):'
    Write-Output ('  1. Remove older dist installers. Keep the ' + $ver + ' pair.')
    Write-Output ('  2. Ask to commit, push, and publish GitHub release v' + $ver + ' with both installers.')
    Write-Output 'This script does not delete installers, commit, push, or create the GitHub release.'
    Write-Output '========================='
}
