#!/bin/bash
set -exuo pipefail

cd ./src/grep

./bootstrap --skip-po --no-git

./configure --prefix=/usr --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
