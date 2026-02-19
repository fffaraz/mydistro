#!/bin/bash
set -x

cd ./src/m4

rmdir ./gnulib
ln -s ../gnulib ./gnulib

./bootstrap --skip-po
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

exit 0
