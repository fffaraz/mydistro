#!/bin/bash
set -exuo pipefail

cd ./src/acl

./autogen.sh

./configure --prefix=/usr --disable-static --disable-nls

make
make install DESTDIR=$INITRAMFS_DIR
