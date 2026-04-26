#!/bin/bash
set -exuo pipefail

cd ./src/automake

./bootstrap

./configure --prefix=/usr
make
make install DESTDIR=$INITRAMFS_DIR
