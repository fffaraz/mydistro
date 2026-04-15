#!/bin/bash
set -exuo pipefail

cd ./src/glibc

mkdir build
cd build

../configure --prefix=/usr

make
make install DESTDIR=/opt/mydistro/initramfs-dir
