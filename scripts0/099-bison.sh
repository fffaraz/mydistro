#!/bin/bash
set -exuo pipefail

cd ./src/bison

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

./configure --disable-nls --disable-shared

make
make install DESTDIR=$INITRAMFS_DIR
