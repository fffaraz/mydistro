#!/bin/bash
set -exuo pipefail

cp -r --reflink=auto ./src-ro ./src

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export PATH=/usr/bin:/usr/sbin
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

COMMON_FLAGS="-O3 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

./scripts/001-fs.sh
./scripts/002-files.sh
./scripts/003-gettext.sh
./scripts/004-bison.sh
./scripts/005-perl.sh
./scripts/006-python.sh
./scripts/007-texinfo.sh
./scripts/008-util-linux.sh
./scripts/009-export1.sh
