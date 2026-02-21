#!/bin/bash
set -exuo pipefail

cd /opt/mydistro

# cp -r --reflink=auto ./src-ro ./src
mkdir -p ./src /tmp/src-upper /tmp/src-work
mount -t overlay overlay -o lowerdir=./src-ro,upperdir=/tmp/src-upper,workdir=/tmp/src-work ./src

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

./scripts/001-fs.sh
./scripts/002-files.sh
./scripts/003-gettext.sh
