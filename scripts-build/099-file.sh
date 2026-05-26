#!/bin/bash
set -exuo pipefail

cd ./src/file

autoreconf -vif

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
