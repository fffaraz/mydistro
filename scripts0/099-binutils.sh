#!/bin/bash
set -exuo pipefail

cd ./src
[ -d ./binutils ] || (tar xf binutils-*.tar.* && mv binutils-*/ binutils)
cd ./binutils

if [ -d ./.git ]; then
	ln -s ../gmp gmp
	ln -s ../mpfr mpfr
fi

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
