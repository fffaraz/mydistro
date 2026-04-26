#!/bin/bash
set -exuo pipefail

cd ./src
tar xf binutils-*.tar.*
mv binutils-*/ binutils
cd ./binutils

mkdir -v build
cd build

../configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-ld=default \
	--enable-plugins \
	--enable-shared \
	--disable-werror \
	--enable-64-bit-bfd \
	--enable-new-dtags \
	--with-system-zlib \
	--enable-default-hash-style=gnu

make tooldir=/usr
make -k check || true

make tooldir=/usr install

rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a /usr/share/doc/gprofng/

cd ../..
rm -rf ./binutils
