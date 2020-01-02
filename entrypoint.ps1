#!/usr/bin/env pwsh
param(
    $FileName,
    $Engine
)

Import-Module (Join-Path $PSScriptRoot actions.psm1)

# Write out diagnostic information.
@{
    "TeX source file" = (Resolve-Path $FileName -ErrorAction Continue);
    "LaTeX engine" = $Engine;
} | Format-Table | Out-String | Write-Host;

$ExtraArgs = @()

if ("xelatex" -eq $Engine) {
    $ExtraArgs += @("-xelatex");
} elseif ("pdflatex" -eq $Engine) {
    $ExtraArgs += @("-pdf");
}

latexmk @ExtraArgs $FileName
$LatexmkExitCode = $LASTEXITCODE
if ($LatexmkExitCode -ne 0) {
    Write-ActionError "latexmk returned exit code $LatexmkExitCode. Check logs for details.";
}
