#!/bin/bash
set -exuo pipefail

cd ./src/gcc

# Link prerequisite libraries into the GCC source tree
ln -sf ../gmp ./gmp
ln -sf ../mpfr ./mpfr
ln -sf ../mpc ./mpc

# Build out-of-tree
mkdir -p build
cd build

../configure \
    --disable-multilib \
    --disable-bootstrap \
    --disable-nls \
    --disable-shared \
    --enable-languages=c,c++

make
make install DESTDIR=/opt/mydistro/initramfs-dir
