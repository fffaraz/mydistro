#!/bin/bash
set -exuo pipefail

cd /opt/mydistro

cp -r --reflink=auto ./src-ro ./src

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

./scripts/001-fs.sh
./scripts/002-files.sh
./scripts/003-perl.sh
./scripts/004-gettext.sh
