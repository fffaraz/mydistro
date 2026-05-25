#!/bin/bash
set -exuo pipefail

cd ./src/wget
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

./configure \
	--prefix=/usr \
	--sysconfdir=/etc \
	--with-ssl=openssl \
	--disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
