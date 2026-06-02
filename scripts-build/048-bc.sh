#!/usr/bin/bash
set -exuo pipefail

cd ./src/bc

# Gavin Howard's bc ships a hand-written configure.sh, not autotools.
#   -G  skip generated tests (they need a pre-existing bc to diff against)
#   -O3 its own optimization level (CFLAGS' -O3 alone is ignored by configure.sh)
#   -M  don't install man pages — nothing in the initramfs reads them
#   -N  no NLS; locales ignore --prefix and would escape the DESTDIR otherwise
CC=gcc ./configure.sh --prefix=/usr -G -O3 -M -N

make
make install DESTDIR=$INITRAMFS_DIR
