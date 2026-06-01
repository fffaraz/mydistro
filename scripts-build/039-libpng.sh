#!/usr/bin/bash
set -exuo pipefail

cd ./src/libpng

# ./autogen.sh

./configure --prefix=/usr --disable-static

make
make install DESTDIR=$INITRAMFS_DIR
make install
