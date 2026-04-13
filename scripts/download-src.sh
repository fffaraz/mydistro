#!/bin/bash
set -euo pipefail

# download-src.sh downloads source code for all dependencies

for cmd in curl git md5sum sha256sum tar realpath; do
	if ! command -v "$cmd" &>/dev/null; then
		echo "Error: required command '$cmd' is not installed" >&2
		exit 1
	fi
done

verify_hash() {
	local hash="$1" file="$2"
	if [[ "$hash" == sha256:* ]]; then
		echo "${hash#sha256:}  $file" | sha256sum -c -
	elif [[ "$hash" == md5:* ]]; then
		echo "${hash#md5:}  $file" | md5sum -c -
	else
		echo "$hash  $file" | md5sum -c -
	fi
}

if [[ $# -lt 1 ]]; then
	echo "Usage: $0 <config-file>" >&2
	exit 1
fi

CONFIG="$(realpath "$1")"

if [[ ! -f "$CONFIG" ]]; then
	echo "Error: config file '$CONFIG' not found" >&2
	exit 1
fi

cd ./src

git config --global advice.detachedHead false

while IFS= read -r line || [[ -n "$line" ]]; do
	# Strip leading/trailing whitespace
	line="${line#"${line%%[![:space:]]*}"}"
	line="${line%"${line##*[![:space:]]}"}"

	# Skip empty lines and comments
	[[ -z "$line" || "$line" == \#* ]] && continue

	# Strip inline comments
	line="${line%%#*}"
	line="${line%"${line##*[![:space:]]}"}"

	read -ra fields <<<"$line"

	if [[ ${#fields[@]} -ne 4 ]]; then
		echo "Error: malformed line: $line" >&2
		exit 1
	fi

	dir="${fields[0]}"
	type="${fields[1]}"
	[[ -d "$dir" ]] && {
		echo "  Skipping, '$dir' already exists"
		continue
	}

	if [[ "$type" == "url" ]]; then
		url="${fields[2]}"
		hash="${fields[3]}"
		archive="${url##*/}"
		echo "==> Downloading $dir from $url"
		curl -fL -o "$archive" "$url"
		verify_hash "$hash" "$archive"
		mkdir -p "$dir"
		tar -xf "$archive" -C "$dir" --strip-components=1
		rm -f "$archive"
	elif [[ "$type" == "file" ]]; then
		archive="${fields[2]}"
		hash="${fields[3]}"
		echo "==> Extracting $dir from $archive"
		verify_hash "$hash" "$archive"
		mkdir -p "$dir"
		tar -xf "$archive" -C "$dir" --strip-components=1
	elif [[ "$type" == "patch" ]]; then
		url="${fields[2]}"
		hash="${fields[3]}"
		echo "==> Downloading patch $dir from $url"
		curl -fL -o "$dir" "$url"
		verify_hash "$hash" "$dir"
	elif [[ "$type" == "git" ]]; then
		repo="${fields[2]}"
		branch="${fields[3]}"
		echo "==> Cloning $dir from $repo @ $branch"
		git clone --depth=1 --branch "$branch" "$repo" "$dir"
	else
		echo "Error: unknown type '$type' on line: $line" >&2
		exit 1
	fi

done <"$CONFIG"

echo "All sources downloaded successfully."
