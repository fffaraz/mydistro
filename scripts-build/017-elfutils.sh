#!/bin/bash
set -exuo pipefail

cd ./src/elfutils

autoreconf -i -f

./configure \
	--prefix=/usr \
	--enable-maintainer-mode \
	--disable-debuginfod \
	--disable-libdebuginfod \
	--disable-nls \
	--without-bzlib \
	--without-lzma \
	--without-zstd

make
make install DESTDIR=$INITRAMFS_DIR
