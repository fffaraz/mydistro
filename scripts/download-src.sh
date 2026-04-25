#!/bin/bash
set -euo pipefail

# download-src.sh downloads source code for all dependencies

for cmd in curl git md5sum sha256sum realpath; do
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

cd "$(dirname "$(realpath "$0")")/../src"

while IFS= read -r line || [[ -n "$line" ]]; do
	# Strip carriage returns (handles CRLF line endings)
	line="${line//$'\r'/}"

	# Strip leading/trailing whitespace
	line="${line#"${line%%[![:space:]]*}"}"
	line="${line%"${line##*[![:space:]]}"}"

	# Skip empty lines and comments
	[[ -z "$line" || "$line" == \#* ]] && continue

	# Strip inline comments (only when '#' is preceded by whitespace, to preserve URL fragments)
	line="${line%%[[:space:]]#*}"
	line="${line%"${line##*[![:space:]]}"}"

	read -ra fields <<<"$line"

	if [[ ${#fields[@]} -ne 4 ]]; then
		echo "Error: malformed line: $line" >&2
		exit 1
	fi

	name="${fields[0]}"
	type="${fields[1]}"

	if [[ "$type" == "url" ]]; then
		url="${fields[2]}"
		hash="${fields[3]}"
		if [[ -f "$name" ]]; then
			echo "  Verifying existing '$name'"
			if verify_hash "$hash" "$name"; then
				continue
			fi
			echo "  Hash mismatch — removing and re-downloading '$name'"
			rm -f "$name"
		fi
		echo "==> Downloading $name from $url"
		curl -fL --retry 3 --retry-delay 2 -o "$name" "$url"
		verify_hash "$hash" "$name"
	elif [[ "$type" == "git" ]]; then
		repo="${fields[2]}"
		branch="${fields[3]}"
		if [[ -d "$name" ]]; then
			echo "  Skipping, '$name' already exists"
			continue
		fi
		echo "==> Cloning $name from $repo @ $branch"
		rm -rf "$name.tmp"
		git -c advice.detachedHead=false clone --depth=1 --branch "$branch" "$repo" "$name.tmp"
		mv "$name.tmp" "$name"
	else
		echo "Error: unknown type '$type' on line: $line" >&2
		exit 1
	fi

done <"$CONFIG"

echo "All sources downloaded successfully."
