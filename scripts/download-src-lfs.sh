#!/bin/bash
set -euo pipefail

wget --input-file=./assets/wget-list-systemd \
     --continue \
     --directory-prefix=./src

cd ./src
md5sum -c "./assets/md5sums"
