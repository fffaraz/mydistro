#!/bin/bash
set -exuo pipefail

cd ./src/libxcrypt

# requires git:
# ./autogen.sh

autoreconf -fiv -Wall,error

./configure \
	--prefix=/usr \
	--enable-hashes=strong,glibc \
	--enable-obsolete-api=glibc \
	--disable-static \
	--disable-failure-tokens

make
make install DESTDIR=$INITRAMFS_DIR
make install
