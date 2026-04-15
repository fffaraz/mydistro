#!/bin/bash
set -exuo pipefail

cd ./src/binutils
ln -s ../gmp gmp
ln -s ../mpfr mpfr

mkdir -p build
cd build

../configure \
	--prefix=/usr \
	--disable-nls \
	--disable-shared \
	--disable-multilib \
	--disable-gprofng \
	--disable-gdb \
	--disable-gdbserver

make
make install DESTDIR=$INITRAMFS_DIR
