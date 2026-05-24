#!/bin/bash
set -exuo pipefail

cd ./src/git

make configure
./configure \
	--prefix=/usr \
	--without-tcltk \
	--without-python

make NO_GETTEXT=1
make install NO_GETTEXT=1 DESTDIR=$INITRAMFS_DIR
