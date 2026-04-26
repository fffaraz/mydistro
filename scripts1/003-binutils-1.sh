#!/bin/bash
set -exuo pipefail

cd ./src
tar xf binutils-*.tar.*
mv binutils-*/ binutils
cd ./binutils

mkdir -v build
cd build

../configure --prefix=$LFS/tools \
	--with-sysroot=$LFS \
	--target=$LFS_TGT \
	--disable-nls \
	--enable-gprofng=no \
	--disable-werror \
	--enable-new-dtags \
	--enable-default-hash-style=gnu

make
make install

cd ../..
rm -rf ./binutils
