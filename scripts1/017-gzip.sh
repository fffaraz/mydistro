#!/bin/bash
set -exuo pipefail

cd ./src/gzip

cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr --host=$LFS_TGT CFLAGS="-Wno-error=zero-as-null-pointer-constant"
make
make DESTDIR=$LFS install
