#!/bin/bash
set -exuo pipefail

cd ./src/openssl

./Configure \
	--prefix=/usr \
	--openssldir=/etc/ssl \
	--libdir=lib \
	shared

make
make install DESTDIR=$INITRAMFS_DIR
