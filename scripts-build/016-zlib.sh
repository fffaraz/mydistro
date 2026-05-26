#!/bin/bash
set -exuo pipefail

cd ./src/zlib

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
