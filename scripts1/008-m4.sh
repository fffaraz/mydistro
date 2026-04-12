#!/bin/bash
set -exuo pipefail

cd ./src
[ -d m4 ] || (tar xf m4-*.tar.* && mv m4-*/ m4)
cd ./m4

cp -r --reflink=auto ../gnulib ./gnulib-repo

git config --global --add safe.directory $(pwd)

./bootstrap --skip-po --skip-git --gnulib-srcdir=./gnulib-repo
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
