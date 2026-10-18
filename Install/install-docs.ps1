# Copy shipped Resources into Documents\EditForthWin.
# Files already present are left alone. Config is included.
# Uninstall does not remove the Documents tree.

param(
    [string]$Dest
)

$ErrorActionPreference = 'Stop'
$srcRoot = Join-Path $PSScriptRoot 'Resources'
if (-not (Test-Path -LiteralPath (Join-Path $srcRoot 'Library\BigInteger\big-int.fth'))) {
    Write-Error "Shipped Library was not found beside this script."
    exit 1
}
if (-not $Dest) {
    $Dest = Join-Path $env:USERPROFILE 'Documents\EditForthWin'
}

$script:added = 0

function Copy-Missing {
    param([string]$Src, [string]$Dst)
    if (-not (Test-Path -LiteralPath $Dst)) {
        New-Item -ItemType Directory -Path $Dst | Out-Null
    }
    foreach ($item in (Get-ChildItem -LiteralPath $Src -Force)) {
        $target = Join-Path $Dst $item.Name
        if ($item.PSIsContainer) {
            Copy-Missing $item.FullName $target
        } elseif (-not (Test-Path -LiteralPath $target)) {
            Copy-Item -LiteralPath $item.FullName -Destination $target
            $script:added++
        }
    }
}

foreach ($name in @('Library', 'AutoLoad', 'Docs', 'Config')) {
    $src = Join-Path $srcRoot $name
    if (Test-Path -LiteralPath $src) {
        Copy-Missing $src (Join-Path $Dest $name)
    }
}

Write-Output "EditForthWin resources: $script:added new file(s) in $Dest"
exit 0
