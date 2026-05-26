#!/bin/bash
set -exuo pipefail

cd ./src/flex

./autogen.sh

./configure --disable-nls --disable-shared
make
make install DESTDIR=$INITRAMFS_DIR
