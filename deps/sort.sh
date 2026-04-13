#!/bin/bash
# Sort sources-*.conf files alphabetically by package name, preserving the header.

DIR="$(dirname "$0")"

for FILE in "$DIR"/sources-*.conf; do
	echo "Sorting $FILE"
	{
		# Print header (comments and blank lines at the top)
		sed -n '/^[^#]/q;p' "$FILE"
		# Sort the non-comment, non-empty lines
		grep -v '^#' "$FILE" | grep -v '^$' | sort
	} >"$FILE.tmp" && mv "$FILE.tmp" "$FILE"
done
