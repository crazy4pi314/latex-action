#!/usr/bin/env pwsh
param(
    $FileName,
    $Engine
)

function Write-ActionCommand {
    param(
        [string] $CommandName,
        [hashtable] $Args,
        [string] $Message
    );

    $ArgsAsString = (
        $Args.GetEnumerator()
        | ForEach-Object {
            "$($_.Key)=$($_.Value)"
        }
    ) -join ",";
    Write-Host "::$CommandName $ArgsAsString::$Message";

}

function Set-Output {
    param(
        $Name,
        $Value
    );
    Write-ActionCommand "set-output" -Args @{"Name" = $Value}
}

function Write-ActionError {
    param(
        $Message,
        $File = $null,
        $Line = $null,
        $Column = $null
    );

    $Args = @{}
    if ($null -ne $File) { $Args["file"] = $File; }
    if ($null -ne $Line) { $Args["line"] = $Line; }
    if ($null -ne $Column) { $Args["col"] = $Column; }
    Write-ActionCommand "error" -Message $Message -Args $Args;
}

$ExtraArgs = @()

if ("xelatex" -eq $Engine) {
    $ExtraArgs += @("-xelatex");
} elseif ("pdflatex" -eq $Engine) {
    $ExtraArgs += @("-pdf");
}

Set-Output -Name time -Value (Get-Date)

latexmk @ExtraArgs $FileName
$LatexmkExitCode = $LASTEXITCODE
if ($LatexmkExitCode -ne 0) {
    Write-ActionError "latexmk returned exit code $LatexmkExitCode. Check logs for details.";
}
