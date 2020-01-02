
function Invoke-ActionCommand {
    param(
        [string] $CommandName,
        [hashtable] $Args,
        [string] $Message = ""
    );

    $ArgsAsString = (
        $Args.GetEnumerator()
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
    Invoke-ActionCommand -CommandName "set-output" -Args @{"Name" = $Value}
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
    Invoke-ActionCommand "error" -Message $Message -Args $Args;
}
