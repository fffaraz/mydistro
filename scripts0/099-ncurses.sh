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
ln -svf libtinfow.so.6 "$INITRAMFS_DIR/usr/lib/libtinfo.so.6"
ln -svf libtinfow.so "$INITRAMFS_DIR/usr/lib/libtinfo.so"
ln -svf /usr/lib/libtinfow.so.6 "$INITRAMFS_DIR/lib64/libtinfo.so.6"
ln -svf /usr/lib/libtinfow.so "$INITRAMFS_DIR/lib64/libtinfo.so"
