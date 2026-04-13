#!/bin/bash
set -euo pipefail

SRC_DIR=./src
MD5_FILE=./deps/md5sums
WGET_LIST=./deps/wget-list-systemd

# Build an associative array of filename -> expected md5
declare -A expected_md5
while read -r md5 filename; do
	expected_md5["$filename"]="$md5"
done <"$MD5_FILE"

# Build an associative array of filename -> URL
declare -A file_url
while read -r url; do
	filename=$(basename "$url")
	file_url["$filename"]="$url"
done <"$WGET_LIST"

# Check existing files, remove bad ones, collect missing ones
missing_urls=()
for filename in "${!expected_md5[@]}"; do
	filepath="$SRC_DIR/$filename"
	if [[ -f "$filepath" ]]; then
		actual_md5=$(md5sum "$filepath" | cut -d' ' -f1)
		if [[ "$actual_md5" != "${expected_md5[$filename]}" ]]; then
			echo "Bad checksum: $filename (expected ${expected_md5[$filename]}, got $actual_md5) — removing"
			rm "$filepath"
			missing_urls+=("${file_url[$filename]}")
		else
			echo "OK: $filename"
		fi
	else
		missing_urls+=("${file_url[$filename]}")
	fi
done

# Download missing files
if [[ ${#missing_urls[@]} -gt 0 ]]; then
	echo "Downloading ${#missing_urls[@]} file(s)..."
	printf '%s\n' "${missing_urls[@]}" | wget --input-file=- --continue --timeout=10 --directory-prefix="$SRC_DIR" || true
fi

# Verify all checksums
cd "$SRC_DIR"
md5sum -c "../$MD5_FILE"
