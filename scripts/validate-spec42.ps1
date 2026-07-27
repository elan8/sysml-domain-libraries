param(
    [string]$Spec42Exe = "",
    [ValidateSet("text", "json", "sarif", "junit")]
    [string]$Format = "text",
    [switch]$IncludeDomainDiagnostics
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$methodLibrary = Join-Path $repoRoot "..\mbse-methodology\library"

if (-not (Test-Path $methodLibrary)) {
    throw "Required sibling mbse-methodology/library not found at $methodLibrary. Domain libraries depend on Elan8 Method packages (Elan8RequirementManagement, Elan8RequirementMetadata)."
}

if (-not $Spec42Exe) {
    if ($env:SPEC42_EXE) {
        $Spec42Exe = $env:SPEC42_EXE
    } elseif (Test-Path "C:\Git\elan8\spec42\target\debug\spec42.exe") {
        $Spec42Exe = "C:\Git\elan8\spec42\target\debug\spec42.exe"
    } elseif (Test-Path "C:\Git\spec42\target\debug\spec42.exe") {
        $Spec42Exe = "C:\Git\spec42\target\debug\spec42.exe"
    } else {
        $Spec42Exe = "spec42"
    }
}

$arguments = @(
    "--library-path", (Join-Path $repoRoot "domain"),
    "--library-path", (Join-Path $repoRoot "technical"),
    "--library-path", (Join-Path $repoRoot "generic"),
    "--library-path", (Resolve-Path $methodLibrary),
    "check", $repoRoot,
    "--workspace-root", $repoRoot
)

if ($IncludeDomainDiagnostics) {
    & $Spec42Exe @arguments --format $Format
    exit $LASTEXITCODE
}

if ($Format -ne "text" -and $Format -ne "json") {
    throw "Filtered validation supports -Format text or json. Use -IncludeDomainDiagnostics for raw sarif or junit output."
}

$raw = & $Spec42Exe @arguments --format json
$report = $raw | ConvertFrom-Json

$errorCount = 0
$warningCount = 0
$informationCount = 0

foreach ($document in $report.documents) {
    $kept = @()
    foreach ($diagnostic in $document.diagnostics) {
        if ($diagnostic.source -eq "domain") {
            continue
        }
        $kept += $diagnostic
        switch ($diagnostic.severity) {
            1 { $errorCount++ }
            2 { $warningCount++ }
            3 { $informationCount++ }
            default { }
        }
    }
    $document.diagnostics = @($kept)
}

$report.summary.error_count = $errorCount
$report.summary.warning_count = $warningCount
$report.summary.information_count = $informationCount

if ($Format -eq "json") {
    $report | ConvertTo-Json -Depth 100
} else {
    Write-Output "Spec42 SysML validation: $($report.summary.document_count) documents, $errorCount errors, $warningCount warnings, $informationCount information."
    Write-Output "Domain completeness diagnostics were filtered. Re-run with -IncludeDomainDiagnostics to include them."
}

if ($errorCount -gt 0 -or $warningCount -gt 0) {
    exit 1
}
