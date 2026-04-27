#!/bin/bash
set -exuo pipefail

cd ./src/e2fsprogs

mkdir -p build
cd build

../configure --prefix=/usr \
	--sysconfdir=/etc \
	--enable-elf-shlibs \
	--disable-libblkid \
	--disable-libuuid \
	--disable-uuidd \
	--disable-fsck \
	--disable-nls

make
make install DESTDIR=$INITRAMFS_DIR

rm -fv $INITRAMFS_DIR/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
