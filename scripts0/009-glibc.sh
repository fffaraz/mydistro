#!/bin/bash
set -exuo pipefail

cd ./src/glibc

mkdir build
cd build

echo '+gccwarn-c = -Wno-error' > configparms
../configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
