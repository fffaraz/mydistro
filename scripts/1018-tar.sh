#!/bin/bash
set -exuo pipefail

cd ./src/tar

rmdir paxutils || true
rm paxutils || true
ln -s ../paxutils paxutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) \
            CFLAGS="-Wno-error=missing-variable-declarations -Wno-error=zero-as-null-pointer-constant"

make
make DESTDIR=$LFS install
