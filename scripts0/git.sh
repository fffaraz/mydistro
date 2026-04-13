#!/bin/bash

# compile git
cd ./src/git

make configure
./configure \
	CFLAGS='-O3 -Wall' \
	--prefix=/usr \
	--without-tcltk \
	--without-python

make NO_GETTEXT=1
make install DESTDIR=/opt/mydistro/initramfs-dir NO_GETTEXT=1
