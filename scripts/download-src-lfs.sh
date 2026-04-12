#!/bin/bash
set -euo pipefail

wget --input-file=./assets/wget-list-systemd \
     --continue \
     --directory-prefix=./src

cd ./src
md5sum -c ../assets/md5sums

# Generate sources.conf
while read -r md5 filename; do
  package_name=$(echo "$filename" | sed -E 's/-[0-9].*//')
  echo "$package_name file $filename $md5"
done < ../assets/md5sums > ../sources.conf
