#!/bin/bash
set -exuo pipefail

cd ./src/zlib

./configure --prefix=/usr
make
make install
make install DESTDIR=$INITRAMFS_DIR

rm -fv /usr/lib/libz.a
rm -fv $INITRAMFS_DIR/usr/lib/libz.a
