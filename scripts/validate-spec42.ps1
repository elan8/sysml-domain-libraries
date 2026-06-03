param(
    [string]$Spec42Exe = "",
    [ValidateSet("text", "json", "sarif", "junit")]
    [string]$Format = "text"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

if (-not $Spec42Exe) {
    if ($env:SPEC42_EXE) {
        $Spec42Exe = $env:SPEC42_EXE
    } elseif (Test-Path "C:\Git\spec42\target\debug\spec42.exe") {
        $Spec42Exe = "C:\Git\spec42\target\debug\spec42.exe"
    } else {
        $Spec42Exe = "spec42"
    }
}

& $Spec42Exe `
    --library-path (Join-Path $repoRoot "domain") `
    --library-path (Join-Path $repoRoot "technical") `
    check $repoRoot `
    --workspace-root $repoRoot `
    --format $Format
