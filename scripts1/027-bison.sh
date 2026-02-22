#!/bin/bash
set -exuo pipefail

cd ./src/bison

cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr \
            --host=$LFS_TGT \
            --docdir=/usr/share/doc/bison-3.8.2
make
make DESTDIR=$LFS install
