#!/bin/bash
set -exuo pipefail

cd ./src/gzip

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
