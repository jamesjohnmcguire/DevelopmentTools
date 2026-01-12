param (
	[string]$Root = ".",
	[string[]]$Extensions = @("*.cs", "*.csproj"),
	[switch]$DryRun
)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

Get-ChildItem -Path $Root -Recurse -File -Include $Extensions | ForEach-Object {

	try {
		# Read as text (PowerShell will decode using BOM or fallback ANSI)
		$content = Get-Content $_.FullName -Raw

		if ($DryRun) {
			Write-Host "Would fix: $($_.FullName)"
		}
		else {
			# Rewrite explicitly as UTF-8 without BOM
			[System.IO.File]::WriteAllText($_.FullName, $content, $utf8NoBom)
			Write-Host "Fixed: $($_.FullName)"
		}
	}
	catch {
		Write-Warning "Skipped (error): $($_.FullName) - $_"
	}
}
