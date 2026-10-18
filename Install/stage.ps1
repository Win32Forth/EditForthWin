# Stage the editor, Forth, and VC runtime for one architecture.
# Resources stay in Forth\Resources and are packed from there.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$redist = 'C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Redist\MSVC'
$ver = Get-ChildItem -LiteralPath $redist -Directory |
    Where-Object { $_.Name -match '^\d' } |
    Sort-Object Name -Descending |
    Select-Object -First 1
if (-not $ver) {
    Write-Error "VC redist was not found under $redist"
    exit 1
}

function Stage-Arch {
    param([string]$Arch)
    $editor = Join-Path $root "Edit\build\$Arch"
    $forthName = if ($Arch -eq 'arm64') { 'fortharm64.exe' } else { 'forthx64.exe' }
    $editName = if ($Arch -eq 'arm64') { 'editforthwinarm64.exe' } else { 'editforthwinx64.exe' }
    $forth = Join-Path $root "Forth\build\$Arch\$forthName"
    $edit = Join-Path $editor $editName
    if (-not (Test-Path -LiteralPath $forth)) {
        Write-Error "Missing $forth. Build that architecture first."
        exit 1
    }
    if (-not (Test-Path -LiteralPath $edit)) {
        Write-Error "Missing $edit. Build that architecture first."
        exit 1
    }
    $crtParent = Join-Path $ver.FullName $Arch
    $crt = Get-ChildItem -LiteralPath $crtParent -Directory |
        Where-Object { $_.Name -like 'Microsoft.VC*.CRT' } |
        Select-Object -First 1
    if (-not $crt) {
        Write-Error "VC runtime DLLs were not found in $crtParent"
        exit 1
    }

    $dest = Join-Path $PSScriptRoot "stage\$Arch"
    if (Test-Path -LiteralPath $dest) {
        Remove-Item -LiteralPath $dest -Recurse -Force
    }
    New-Item -ItemType Directory -Path $dest | Out-Null
    Copy-Item -LiteralPath $forth -Destination (Join-Path $dest $forthName)
    Copy-Item -LiteralPath $edit -Destination (Join-Path $dest $editName)
    Get-ChildItem -LiteralPath $editor -File -Filter *.dll | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dest $_.Name)
    }
    $manifest = Join-Path $editor ($editName + '.manifest')
    if (Test-Path -LiteralPath $manifest) {
        Copy-Item -LiteralPath $manifest -Destination (Join-Path $dest ($editName + '.manifest'))
    }
    Get-ChildItem -LiteralPath $crt.FullName -File -Filter *.dll | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dest $_.Name)
    }
    Get-ChildItem -LiteralPath $editor -Directory | ForEach-Object {
        if ($_.Name -eq 'CMakeFiles' -or $_.Name -like '*autogen*') { return }
        $hasDll = Get-ChildItem -LiteralPath $_.FullName -Recurse -Filter *.dll -ErrorAction SilentlyContinue |
            Select-Object -First 1
        if ($hasDll) {
            Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $dest $_.Name) -Recurse
        }
    }
    Write-Output "Staged $Arch -> $dest"
}

Stage-Arch 'arm64'
Stage-Arch 'x64'
exit 0
