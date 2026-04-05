#!/bin/bash
set -euo pipefail

# download-src.sh downloads source code for all dependencies

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

git config --global advice.detachedHead false

while IFS= read -r line || [[ -n "$line" ]]; do
    # Strip leading/trailing whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # Skip empty lines and comments
    [[ -z "$line" || "$line" == \#* ]] && continue

    read -ra fields <<< "$line"

    if [[ ${#fields[@]} -ne 4 ]]; then
        echo "Warning: skipping malformed line: $line" >&2
        continue
    fi

    dir="${fields[0]}"
    type="${fields[1]}"
    [[ -d "$dir" ]] && { echo "  Skipping, '$dir' already exists"; continue; }

    if [[ "$type" == "file" ]]; then
        url="${fields[2]}"
        md5="${fields[3]}"
        archive="${url##*/}"
        echo "==> Downloading $dir from $url"
        curl -fL -o "$archive" "$url"
        echo "$md5  $archive" | md5sum -c -
        mkdir -p "$dir"
        tar -xf "$archive" -C "$dir" --strip-components=1
        rm -f "$archive"
    elif [[ "$type" == "git" ]]; then
        repo="${fields[2]}"
        branch="${fields[3]}"
        echo "==> Cloning $dir from $repo @ $branch"
        git clone --depth=1 --branch "$branch" "$repo" "$dir"
    else
        echo "Warning: unknown type '$type' on line: $line" >&2
    fi

done < "$CONFIG"
