[CmdletBinding()]
param(
    [Parameter(Mandatory = $false, Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Patterns = @("."),

    [Parameter(Mandatory = $false)]
    [switch]$Recurse
)

$files = foreach ($pattern in $Patterns) {
    if (Test-Path $pattern -PathType Container) {
        Get-ChildItem -Path $pattern -Recurse:$Recurse -File
    } else {
        # For glob patterns, check parent directory recursively
        $parent = Split-Path $pattern -Parent
        $leaf = Split-Path $pattern -Leaf
        if (-not $parent) { $parent = "." }
        Get-ChildItem -Path $parent -Filter $leaf -Recurse:$Recurse -File
    }
}

if (-not $files) {
    Write-Host "No files found matching: $($Patterns -join ', ')"
    exit 1
}

$files | ForEach-Object {
    dos2unix $_.FullName
    Write-Host "LF fixed: $($_.FullName)"
}

Write-Host "Dos2Unix All Complete"
