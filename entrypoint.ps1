#!/usr/bin/env pwsh
param(
    $Name
)

function Set-Output {
    param(
        $Name,
        $Value
    );
    Write-Host "::set-output name=$Name::$Value";

}

Write-Host "Hello $Name"
Set-Output -Name time -Value (Get-Date)

