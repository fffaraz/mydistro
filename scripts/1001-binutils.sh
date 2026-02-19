#!/bin/bash
set -x

cd ./src/binutils-gdb

ln -s ../gmp gmp
ln -s ../mpfr mpfr

mkdir -v build
cd build

../configure --prefix=/opt/mydistro/initramfs-dir/tools \
             --with-sysroot=/opt/mydistro/initramfs-dir \
             --target=x86_64-mydistro-linux-gnu \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu

make -j$(nproc)

make install
