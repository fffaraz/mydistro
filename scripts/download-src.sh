#!/bin/bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <config-file>" >&2
    exit 1
fi

CONFIG="$1"

if [[ ! -f "$CONFIG" ]]; then
    echo "Error: config file '$CONFIG' not found" >&2
    exit 1
fi

cd ./src

while IFS= read -r line || [[ -n "$line" ]]; do
    # Strip leading/trailing whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    read -ra fields <<< "$line"

    dir="${fields[0]}"

    if [[ ${#fields[@]} -eq 2 ]]; then
        # tar.gz download
        url="${fields[1]}"
        archive="${url##*/}"
        echo "==> Downloading $dir from $url"
        [[ -d "$dir" ]] && { echo "  Skipping, '$dir' already exists"; continue; }
        curl -fL -o "$archive" "$url"
        mkdir -p "$dir"
        tar -xf "$archive" -C "$dir" --strip-components=1
        rm -f "$archive"

    elif [[ ${#fields[@]} -eq 3 ]]; then
        # git clone
        repo="${fields[1]}"
        branch="${fields[2]}"
        echo "==> Cloning $dir from $repo @ $branch"
        [[ -d "$dir" ]] && { echo "  Skipping, '$dir' already exists"; continue; }
        git clone --depth=1 --branch "$branch" "$repo" "$dir"

    else
        echo "Warning: skipping malformed line: $line" >&2
    fi

done < "$CONFIG"
