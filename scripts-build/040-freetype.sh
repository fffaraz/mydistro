#!/bin/bash
set -exuo pipefail

cd ./src/freetype

./autogen.sh
./configure --prefix=/usr --enable-freetype-config --disable-static --with-harfbuzz=no --with-brotli=no
make
make install
make install DESTDIR=$INITRAMFS_DIR
