[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Path = @(".")
)

$filesToProcess = [System.Collections.Generic.List[IO.FileInfo]]::new()

Get-ChildItem -Path $Root -Recurse -File |
	Where-Object { $Extensions -contains $_.Extension } |
	ForEach-Object {
		dos2unix $_.FullName
		Write-Host "LF fixed: $($_.FullName)"
	}

