#!/bin/bash
set -exuo pipefail

cd ./src/glibc

ln -s ../mpfr mpfr
ln -s ../gmp gmp
ln -s ../mpc mpc

mkdir build
cd build

../configure --disable-nls --enable-languages=c,c++

make
make install DESTDIR=/opt/mydistro/initramfs-dir
