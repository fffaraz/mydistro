#!/bin/bash
set -exuo pipefail

cd ./src/libexpat/expat

./buildconf.sh

./configure --prefix=/usr --disable-static

make
make install DESTDIR=$INITRAMFS_DIR
