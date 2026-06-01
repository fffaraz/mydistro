#!/usr/bin/bash
set -exuo pipefail

cd ./src/xz
autoreconf -vif

./configure --prefix=/usr --disable-static

make
make install DESTDIR=$INITRAMFS_DIR
