param (
    [string]$Root = "."
)

$Extensions = @(".cs", ".csproj")

Get-ChildItem -Path $Root -Recurse -File |
	Where-Object { $Extensions -contains $_.Extension } |
	ForEach-Object {
		dos2unix $_.FullName
		Write-Host "LF fixed: $($_.FullName)"
	}

