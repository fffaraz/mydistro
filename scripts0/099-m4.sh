#!/bin/bash
set -exuo pipefail

cd ./src/m4
./bootstrap --skip-po --skip-git

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
