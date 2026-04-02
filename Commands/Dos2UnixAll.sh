#!/usr/bin/env bash

recurse=false
patterns=()

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        -r|--recurse)
            recurse=true
            ;;
        *)
            patterns+=("$arg")
            ;;
    esac
done

# Default to current directory if no patterns given
if [ ${#patterns[@]} -eq 0 ]; then
    patterns=(".")
fi

files=()

for pattern in "${patterns[@]}"; do
    if [ -d "$pattern" ]; then
        # It's a directory
        if [ "$recurse" = true ]; then
            while IFS= read -r -d '' f; do
                files+=("$f")
            done < <(find "$pattern" -type f -print0)
        else
            while IFS= read -r -d '' f; do
                files+=("$f")
            done < <(find "$pattern" -maxdepth 1 -type f -print0)
        fi
    else
        # It's a glob or file pattern
        if [ "$recurse" = true ]; then
            parent=$(dirname "$pattern")
            leaf=$(basename "$pattern")
            while IFS= read -r -d '' f; do
                files+=("$f")
            done < <(find "$parent" -name "$leaf" -type f -print0)
        else
            # Let the shell expand the glob
            for f in $pattern; do
                [ -f "$f" ] && files+=("$f")
            done
        fi
    fi
done

if [ ${#files[@]} -eq 0 ]; then
    echo "No files found matching: ${patterns[*]}"
    exit 1
fi

for f in "${files[@]}"; do
    dos2unix "$f"
    echo "LF fixed: $f"
done

echo "Dos2Unix All Complete"
