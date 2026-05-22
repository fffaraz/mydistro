#!/bin/bash
set -exuo pipefail

cd ./src/nasm

./autogen.sh
./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
