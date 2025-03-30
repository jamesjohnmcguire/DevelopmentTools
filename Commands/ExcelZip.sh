#!/bin/bash

# Check if directory is provided
if [ -z "$1" ]
  then
    echo "Usage: %0 <folder name>"
	exit 1
fi

# Define variables
ContentsDirectory=$1
OutputFile=$(basename $ContentsDirectory .contents)

cd $ContentsDirectory

zip -r ../$OutputFile .

if [ $? -ne 0 ]; then
	echo "Error: Failed to extract $ExcelFile"
	exit 1
fi

cd ..

echo "Successfully rebuilt $ExcelFile"
exit 0
