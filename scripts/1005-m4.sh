#!/bin/bash
set -exuo pipefail

cd ./src/m4

rmdir ./gnulib
cp -r --reflink=auto ../gnulib ./gnulib

git config --global --add safe.directory $(pwd)

./bootstrap --skip-po --skip-git --gnulib-srcdir=./gnulib
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
