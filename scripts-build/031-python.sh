#!/bin/bash
set -exuo pipefail

cd ./src/cpython

./configure \
	--prefix=/usr \
	--enable-shared \
	--without-ensurepip \
	--without-static-libpython

make
make install DESTDIR=$INITRAMFS_DIR
