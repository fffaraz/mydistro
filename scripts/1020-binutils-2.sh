#!/bin/bash
set -exuo pipefail

cd ./src/binutils-gdb

sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build2
cd build2

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu \
    --disable-gdb              \
    --disable-gdbserver

make
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}
