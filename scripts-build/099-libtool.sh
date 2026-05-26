#!/bin/bash
set -exuo pipefail

cd ./src/libtool

./bootstrap

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
