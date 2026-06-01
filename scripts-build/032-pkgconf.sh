#!/usr/bin/bash
set -exuo pipefail

cd ./src/pkgconf

./autogen.sh
./configure \
	--prefix=/usr \
	--with-system-libdir=/usr/lib:/usr/lib64 \
	--with-system-includedir=/usr/include
make
make install DESTDIR=$INITRAMFS_DIR

# Also install into the current container so the very next build step
# (nano's autoreconf) can find pkg.m4 and the pkg-config binary.
make install
ln -sfv pkgconf /usr/bin/pkg-config
ln -sfv pkgconf $INITRAMFS_DIR/usr/bin/pkg-config
