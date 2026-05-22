#!/bin/bash
set -exuo pipefail

cd ./src/libxcrypt

./autogen.sh

./configure --prefix=/usr \
	--enable-hashes=strong,glibc \
	--enable-obsolete-api=glibc \
	--disable-static \
	--disable-failure-tokens

make
make install DESTDIR=$INITRAMFS_DIR
