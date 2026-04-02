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
    # Strip any trailing newlines — we'll add exactly one at the end
    $text = $text.TrimEnd("`n")
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
    $usingEnd = $i - 1

    # Allow blank lines after usings
    while ($i -lt $count -and $lines[$i] -match '^\s*$') {
        $i++
    }

    # 3. Expect namespace line
    if ($i -ge $count -or $lines[$i] -notmatch '^\s*namespace\s+[^;]+;\s*$|^\s*namespace\s+[^{\s]+') {
        return
    }
    $namespaceLineIndex = $i

    # Build header (everything before the using statements)
    $header = if ($usingStart -gt 0) { $lines[0..($usingStart - 1)] } else { @() }

    # File-scoped namespace: 'namespace Foo.Bar;'
    if ($lines[$i] -match '^\s*namespace\s+[^;]+;\s*$') {
        $newLines = @()
        $newLines += $header
        $newLines += $lines[$namespaceLineIndex]
        $newLines += ""
        $newLines += $usings
        # Rest of file after the namespace line, skipping any leading blank line
        $restStart = $namespaceLineIndex + 1
        while ($restStart -lt $count -and $lines[$restStart] -match '^\s*$') {
            $restStart++
        }
        if ($restStart -lt $count) {
            $newLines += ""
            $newLines += $lines[$restStart..($count - 1)]
        }
    }
    else {
        # Block namespace (Allman style) — find opening brace
        $j = $i + 1
        while ($j -lt $count -and $lines[$j] -match '^\s*$') {
            $j++
        }
        if ($j -ge $count -or $lines[$j] -notmatch '^\s*\{\s*$') {
            return
        }
        $braceLine = $lines[$j]
        $indent = ($braceLine -replace '^(\s*).*$','$1') + "`t"
        $indentedUsings = $usings | ForEach-Object { $indent + ($_ -replace '^\s*','') }
        $newLines = @()
        $newLines += $header
        $newLines += $lines[$namespaceLineIndex..$j]
        $newLines += $indentedUsings
        $newLines += ""
        $newLines += $lines[($j + 1)..($count - 1)]
    }

    # Join and add exactly one trailing newline
    $newText = ($newLines -join "`n") + "`n"

    if ($newText -ne ($text + "`n")) {
        if ($WhatIf) {
            Write-Host "Would update: $path"
        }
        else {
            $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
            [IO.File]::WriteAllText($path, $newText, $utf8NoBom)
            Write-Host "Updated: $path"
        }
    }
}
