#!/usr/bin/bash
set -exuo pipefail

cd ./src

tar xf help2man.tar.xz
mv help2man-*/ help2man

cd help2man

./configure --prefix=/usr --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
