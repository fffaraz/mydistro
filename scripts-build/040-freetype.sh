#!/bin/bash
set -exuo pipefail

cd ./src/freetype

# git clean -dxf

./autogen.sh
./configure --prefix=/usr --enable-freetype-config --disable-static --with-harfbuzz=no --with-brotli=no
make
make install
make install DESTDIR=$INITRAMFS_DIR

# zlib (016-zlib.sh) and libpng (039-libpng.sh) are dependencies, build them first
# microwindows (007-microwindows.sh) needs the freetype headers at /usr/include/freetype2
# freetype installs to /usr (host) and $INITRAMFS_DIR
