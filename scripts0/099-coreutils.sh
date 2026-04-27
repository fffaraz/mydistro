#!/bin/bash
set -exuo pipefail

cd ./src/coreutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
rm -f ./gl/top/maint.mk.diff
./bootstrap --skip-po --gnulib-srcdir=./gnulib-repo

./configure --prefix=/usr \
	--enable-install-program=hostname \
	--enable-no-install-program=kill,uptime \
	--disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
