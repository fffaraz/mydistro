#!/bin/bash
set -exuo pipefail

cd ./src/attr

./autogen.sh

./configure --prefix=/usr \
	--disable-static \
	--sysconfdir=/etc \
	--disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
