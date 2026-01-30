param (
    [string]$Root = ".",
    [switch]$WhatIf
)

Get-ChildItem -Path $Root -Recurse -File -Filter *.cs |
    Where-Object {
        $_.FullName -notmatch '\\bin\\' -and
        $_.FullName -notmatch '\\obj\\'
    } |
    ForEach-Object {

    $path = $_.FullName
    $text = Get-Content -LiteralPath $path -Raw -Encoding UTF8
    $text = $text -replace "`r`n", "`n"

    $lines = $text -split "`n"

    $i = 0
    $count = $lines.Count

    # 1. Skip header: blank lines and any // or /* */ comment lines
    while ($i -lt $count) {
        $line = $lines[$i]

        if ($line -match '^\s*$' -or
            $line -match '^\s*//' -or
            $line -match '^\s*/\*' -or
            $line -match '^\s*\*' -or
            $line -match '^\s*.*\*/\s*$')
        {
            $i++
            continue
        }

        break
    }

    # 2. Collect top-level using statements
    $usingStart = $i
    $usings = @()

    while ($i -lt $count -and $lines[$i] -match '^\s*using\s+[^\s;].*;\s*$') {
        $usings += $lines[$i]
        $i++
    }

    if ($usings.Count -eq 0) {
        return
    }

    # Allow blank lines after usings
    while ($i -lt $count -and $lines[$i] -match '^\s*$') {
        $i++
    }

    # 3. Expect namespace line
    if ($i -ge $count -or $lines[$i] -notmatch '^\s*namespace\s+[^;]+;\s*$|^\s*namespace\s+[^{\s]+') {
        # Not a standard namespace layout — skip
        return
    }

    $namespaceLineIndex = $i

    # File-scoped namespace
    if ($lines[$i] -match '^\s*namespace\s+[^;]+;\s*$') {

        # Insert usings after this line
        $insertIndex = $i + 1

        # Remove original usings
        $newLines = @()
        $newLines += $lines[0..($usingStart - 1)]
        $newLines += $lines[$i..($i)]
		$newLines += ""
        $newLines += $usings
        $newLines += $lines[($i + 1)..($count - 1)]

    }
    else {
        # Block namespace (Allman style)

        # Find the opening brace line
        $j = $i + 1
        while ($j -lt $count -and $lines[$j] -match '^\s*$') {
            $j++
        }

        if ($j -ge $count -or $lines[$j] -notmatch '^\s*\{\s*$') {
            # No brace found — skip
            return
        }

        # Determine indentation (tabs preserved)
        $braceLine = $lines[$j]
        $indent = ($braceLine -replace '^(\s*).*$','$1') + "`t"

        $indentedUsings = $usings | ForEach-Object { $indent + ($_ -replace '^\s*','') }

        # Build new file
        $newLines = @()
        $newLines += $lines[0..($usingStart - 1)]          # header
        $newLines += $lines[$namespaceLineIndex..$j]      # namespace + {
        $newLines += $indentedUsings                       # moved usings
		$newLines += ""
        $newLines += $lines[($j + 1)..($count - 1)]       # rest of file
    }

    $newText = ($newLines -join "`n")

    if ($newText -ne $text) {
        if ($WhatIf) {
            Write-Host "Would update: $path"
        }
        else {
            Set-Content -LiteralPath $path -Value $newText -Encoding UTF8
            Write-Host "Updated: $path"
        }
    }
}
