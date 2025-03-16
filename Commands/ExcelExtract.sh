#!/bin/bash

# Define variables
ExcelFile=$1
ExtractDirecory=$ExcelFile.Contents

# Create or clear extraction directory
if [ -d "$ExtractDirecory" ]; then
	rm -rf "$ExtractDirecory"
fi
	mkdir "$ExtractDirecory"

# Extract the xlsx file
echo "Extracting $ExcelFile to $ExtractDirecory..."
7z x "$ExcelFile" -o"$ExtractDirecory" -y >/dev/null
if [ $? -ne 0 ]; then
	echo "Error: Failed to extract $ExcelFile"
	exit 1
fi

echo "Extraction complete!"
exit 0