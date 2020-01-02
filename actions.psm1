
function Invoke-ActionCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $CommandName,
        
        [hashtable]
        $Arguments = @{},

        [string]
        $Message = ""
    );

    $ArgsAsString = (
        $Arguments.GetEnumerator() `
            | ForEach-Object {
                "$($_.Key)=$($_.Value)"
            }
    ) -join ",";
    Write-Host "::$CommandName $ArgsAsString::$Message";

}

function Set-ActionOutput {
    param(
        $Name,
        $Value
    );
    Invoke-ActionCommand -CommandName "set-output" -Arguments @{"Name" = $Value}
}

function Set-ActionEnvionrmentVariable {
    param(
        $Name,
        $Value = $null
    );
    Invoke-ActionCommand "set-env" -Arguments @{"Name" = $Name} -Message $Value
}

function Write-ActionError {
    param(
        $Message,
        $File = $null,
        $Line = $null,
        $Column = $null
    );

    $Arguments = @{}
    if ($null -ne $File) { $Arguments["file"] = $File; }
    if ($null -ne $Line) { $Arguments["line"] = $Line; }
    if ($null -ne $Column) { $Arguments["col"] = $Column; }
    Write-Debug $Arguments;
    Invoke-ActionCommand -CommandName "error" -Message $Message -Arguments $Arguments;
}
