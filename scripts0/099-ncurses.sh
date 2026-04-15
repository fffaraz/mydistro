#!/bin/bash
set -exuo pipefail

cd ./src/ncurses

./configure \
	--prefix=/usr \
	--mandir=/usr/share/man \
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
ln -svf libncursesw.so "$INITRAMFS_DIR/usr/lib/libncurses.so"
