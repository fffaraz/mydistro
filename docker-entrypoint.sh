#!/bin/bash
set -exuo pipefail

export TERM=xterm-256color

cd /opt/mydistro

# cp -r --reflink=auto ./src-ro ./src
mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

./scripts/000-build.sh
