#!/bin/bash
set -x

cd ./src/m4

./bootstrap --skip-po --skip-git --gnulib-srcdir=../gnulib
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

exit 0
