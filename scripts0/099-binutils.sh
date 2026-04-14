#!/bin/bash
set -exuo pipefail

cd ./src/binutils

mkdir -p build
cd build

../configure \
    --prefix=/usr \
    --disable-nls \
    --disable-shared \
    --disable-multilib

make
make install DESTDIR=/opt/mydistro/initramfs-dir
