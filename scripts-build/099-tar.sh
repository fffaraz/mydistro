#!/bin/bash
set -exuo pipefail

cd ./src/tar

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
