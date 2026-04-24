#!/bin/bash
set -exuo pipefail

cp -r --reflink=auto ./src-ro ./src

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

COMMON_FLAGS="-O2 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

./scripts/001-fs.sh
./scripts/002-files.sh
./scripts/003-perl.sh
./scripts/004-gettext.sh
./scripts/005-python.sh
./scripts/006-texinfo.sh
./scripts/007-util-linux.sh
./scripts/008-export.sh
