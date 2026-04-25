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
