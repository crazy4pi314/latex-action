#!/usr/bin/env pwsh
param(
    $InputsAsJson
)

$Inputs = $InputsAsJson | ConvertFrom-Json;
$FileName = $Inputs.source;
$Engine = $Inputs.engine;
$WorkingDirectory = $Inputs."working-directory";

Import-Module (Join-Path $PSScriptRoot actions.psm1)
if ("" -eq "$WorkingDirectory") {
    Write-Host "Setting working directory to $WorkingDirectory"
    Set-Location (Join-Path "/github/workspace" $WorkingDirectory)
}

# Write out diagnostic information.
@{
    "TeX source file" = (Resolve-Path $FileName -ErrorAction Continue);
    "LaTeX engine" = $Engine;
    "pwsh version" = $PSVersionTable.PSVersion;
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
    Write-ActionError -Message "latexmk returned exit code $LatexmkExitCode. Check logs for details.";
    exit $LatexmkExitCode
}
