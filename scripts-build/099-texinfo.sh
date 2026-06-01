#!/usr/bin/bash
set -exuo pipefail

cd ./src/texinfo

./autogen.sh

./configure --prefix=/usr --disable-nls
make
make install DESTDIR=$INITRAMFS_DIR
