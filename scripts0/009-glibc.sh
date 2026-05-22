#!/bin/bash
set -exuo pipefail

cd ./src/glibc

mkdir build
cd build

../configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
