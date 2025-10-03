#!/bin/bash

# Check if file argument provided
if [ -z "$1" ]; then
    echo "Usage: fix.sh sql_file.sql"
    exit 1
fi

# Check if file exists
if [ ! -f "$1" ]; then
    echo "Error: File '$1' not found"
    exit 1
fi

echo "Fixing SQL file: $1"

# Add UTF-8 settings at the beginning
sed -i '1i SET NAMES utf8mb4;' "$1"
sed -i '2i SET CHARACTER_SET_CLIENT = utf8mb4;' "$1"
sed -i '3i SET CHARACTER_SET_CONNECTION = utf8mb4;' "$1"

# Fix deprecated integer type specifications
sed -i 's|bigint([0-9]*)|bigint|g' "$1"
sed -i 's|int([0-9]*)|int|g' "$1"
sed -i 's|smallint([0-9]*)|smallint|g' "$1"
sed -i 's|tinyint([0-9]*)|tinyint|g' "$1"

# Fix zero dates
sed -i 's|datetime DEFAULT '0000-00-00 00:00:00'|datetime DEFAULT NULL|g' "$1"
sed -i 's|NOT NULL DEFAULT '0000-00-00 00:00:00'|DEFAULT NULL|g' "$1"
sed -i 's|'0000-00-00 00:00:00'|NULL|g' "$1"

sed -i 's|longtext NOT NULL,|longtext NOT NULL DEFAULT (''),|g' "$1"

# Fix charset from latin1 to utf8mb4
sed -i 's|DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci|DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci|g' "$1"
sed -i 's|CHARSET=latin1|CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci|g' "$1"
sed -i 's|CHARACTER SET latin1|CHARACTER SET utf8mb4|g' "$1"

echo "Done!"
