#!/bin/bash
set -x

cd ./src/binutils-gdb

ln -s ../gmp gmp
ln -s ../mpfr mpfr

mkdir -v build
cd build

../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make -j$(nproc)

make install
