#!/bin/bash
set -exuo pipefail

cd ./src
tar xf binutils-*.tar.*
mv binutils-*/ binutils
cd ./binutils

sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build
cd build

../configure \
	--prefix=/usr \
	--build=$(../config.guess) \
	--host=$LFS_TGT \
	--disable-nls \
	--enable-shared \
	--enable-gprofng=no \
	--disable-werror \
	--enable-64-bit-bfd \
	--enable-new-dtags \
	--enable-default-hash-style=gnu \
	--disable-gdb \
	--disable-gdbserver

make
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd ../..
rm -rf ./binutils
