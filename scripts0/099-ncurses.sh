#!/bin/bash
set -exuo pipefail

cd ./src/ncurses

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
