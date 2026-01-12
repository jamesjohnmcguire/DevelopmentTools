#!/bin/bash

echo "Moving using statements inside namespaces for all .cs files..."
echo ""

count=0

# Find all .cs files recursively
while IFS= read -r -d '' file; do
	echo "Processing: $file"

	# Check if file has a namespace
	if ! grep -q "^[[:space:]]*namespace " "$file"; then
		echo "  [No namespace found - skipped]"
		echo ""
		continue
	fi

	# Create temporary file
	tempfile="${file}.tmp"

	# Process the file
	awk '
		BEGIN {
			in_namespace = 0
			namespace_found = 0
			namespace_indent = ""
		}

		# Store using statements
		/^[[:space:]]*using / && in_namespace == 0 {
			usings[++using_count] = $0
			next
		}

		# When we hit the namespace declaration
		/^[[:space:]]*namespace / {
			namespace_found = 1
			in_namespace = 1

			# Print the namespace line
			print $0

			# Detect indentation (count leading spaces/tabs)
			match($0, /^[[:space:]]*/)
			namespace_indent = substr($0, 1, RLENGTH) "    "

			# Print all collected using statements with proper indentation
			for (i = 1; i <= using_count; i++) {
				# Remove leading whitespace from using statement
				gsub(/^[[:space:]]*/, "", usings[i])
				print namespace_indent usings[i]
			}

			# Print blank line after usings if there were any
			if (using_count > 0) {
				print ""
			}

			next
		}

		# Print all other lines as-is
		{
			print $0
		}
	' "$file" > "$tempfile"

	# Check if any changes were made
	if ! cmp -s "$file" "$tempfile"; then
		mv "$tempfile" "$file"
		((count++))
		echo "  [Modified]"
	else
		rm "$tempfile"
		echo "  [No changes needed]"
	fi

	echo ""
done < <(find . -type f -name "*.cs" -print0)

echo ""
echo "Completed! Modified $count file(s)."
