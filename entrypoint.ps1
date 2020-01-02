#!/usr/bin/env pwsh
param(
    $FileName,
    $Engine
)

function Set-Output {
    param(
        $Name,
        $Value
    );
    Write-Host "::set-output name=$Name::$Value";

}

$ExtraArgs = @()

if ("xelatex" -eq $Engine) {
    $ExtraArgs += @("-xelatex");
} elseif ("pdflatex" -eq $Engine) {
    $ExtraArgs += @("-pdf");
}

Set-Output -Name time -Value (Get-Date)

latexmk @ExtraArgs $FileName
