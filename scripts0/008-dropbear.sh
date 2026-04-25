#!/bin/bash
set -exuo pipefail

cd ./src/dropbear

./configure  --prefix=/usr --mandir=/tmp/dropbear-man

make
make install DESTDIR=$INITRAMFS_DIR
