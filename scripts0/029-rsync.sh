#!/bin/bash
set -exuo pipefail

cd ./src/rsync

./configure --prefix=/usr \
	--disable-md2man \
	--disable-xxhash \
	--disable-zstd \
	--disable-lz4 \
	--disable-openssl

make
make install DESTDIR=$INITRAMFS_DIR
