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
    --prefix=/usr \
    --disable-bootstrap \
    --disable-multilib \
    --disable-nls \
    --enable-languages=c,c++

make
make install DESTDIR=$INITRAMFS_DIR

# echo 'int main(){return 0;}' | gcc -x c - -o /tmp/test && /tmp/test && echo OK
