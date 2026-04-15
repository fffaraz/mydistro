#!/bin/bash
set -exuo pipefail

cd ./src/musl

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
