#!/usr/bin/bash
set -exuo pipefail

cd ./src/cpython

./configure \
	--prefix=/usr \
	--enable-shared \
	--without-ensurepip \
	--without-static-libpython \
	--disable-test-modules

make
make install DESTDIR=$INITRAMFS_DIR

find "$INITRAMFS_DIR" -name "__pycache__" -type d -exec rm -rf {} +
find "$INITRAMFS_DIR" -name "*.pyc" -type f -delete
