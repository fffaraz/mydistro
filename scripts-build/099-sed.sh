#!/usr/bin/bash
set -exuo pipefail

cd ./src/sed

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

./configure --prefix=/usr --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
