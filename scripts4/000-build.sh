#!/bin/bash
set -exuo pipefail

mkdir -p ./src
cp --reflink=auto ./src-ro/linux-*.tar.* ./src/

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export PATH=/usr/bin:/usr/sbin:/bin:/sbin
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

COMMON_FLAGS="-O3 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

./scripts/001-files.sh
./scripts/002-systemd.sh
./scripts/003-fstab.sh
./scripts/004-kernel.sh
./scripts/005-grub.sh
./scripts/006-export.sh
