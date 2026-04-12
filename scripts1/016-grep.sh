#!/bin/bash
set -exuo pipefail

cd ./src
[ -d grep ] || (tar xf grep-*.tar.* && mv grep-*/ grep)
cd ./grep

cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess) \
            CFLAGS="-Wno-error=zero-as-null-pointer-constant"

make
make DESTDIR=$LFS install
