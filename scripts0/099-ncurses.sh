#!/bin/bash
set -exuo pipefail

cd ./src/ncurses

./configure \
	--prefix=/usr \
	--mandir=/tmp/ncurses-man \
	--with-shared \
	--with-termlib \
	--without-normal \
	--with-cxx-shared \
	--without-debug \
	--without-ada \
	--disable-stripping \
	AWK=gawk

make
make install DESTDIR=$INITRAMFS_DIR

ln -s libtinfow.so.6 $INITRAMFS_DIR/usr/lib/libtinfo.so.6
