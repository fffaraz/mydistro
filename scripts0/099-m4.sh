#!/bin/bash
set -exuo pipefail

cd ./src/m4
cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --skip-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
