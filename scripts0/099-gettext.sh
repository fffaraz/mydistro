#!/bin/bash
set -exuo pipefail

cd ./src/gettext

./autogen.sh

./configure --prefix=/usr --disable-static

make
make install DESTDIR=$INITRAMFS_DIR
