param (

	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$Paths = @(
		"*.cs",
		"*.csproj"
	)
)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

# Collect files
$files = foreach ($path in $Paths) {

	# Explicit file
	if (Test-Path $path -PathType Leaf) {

		Get-Item $path
		continue
	}

	# Wildcard search
	Get-ChildItem `
		-Recurse `
		-File `
		-ErrorAction SilentlyContinue |
		Where-Object {
			$_.Name -like $path
		}
}

# Remove duplicates
$files = foreach ($path in $Paths) {

	# Explicit file
	if (Test-Path $path -PathType Leaf) {

		Get-Item $path
		continue
	}

	# Wildcard search
	Get-ChildItem `
		-Recurse `
		-File `
		-ErrorAction SilentlyContinue |
		Where-Object {
			$_.Name -like $path
		}
}

$files = $files |
	Sort-Object FullName -Unique

foreach ($file in $files) {

	try {

		# Read raw bytes
		$bytes = [System.IO.File]::ReadAllBytes($file.FullName)

		# Detect UTF-8 BOM
		$hasBom =
			$bytes.Length -ge 3 -and
			$bytes[0] -eq 0xEF -and
			$bytes[1] -eq 0xBB -and
			$bytes[2] -eq 0xBF

		if (-not $hasBom) {
			continue
		}

		# Decode skipping BOM bytes
		$content = [System.Text.Encoding]::UTF8.GetString(
			$bytes,
			3,
			$bytes.Length - 3
		)

		# Rewrite as UTF-8 without BOM
		[System.IO.File]::WriteAllText(
			$file.FullName,
			$content,
			$utf8NoBom
		)

		Write-Host "Removed BOM: $($file.FullName)"
	}
	catch {

		Write-Warning "Skipped (error): $($file.FullName)"
		Write-Warning $_
	}
}

Write-Host ""
Write-Host "Done."
