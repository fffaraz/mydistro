#!/bin/bash
set -exuo pipefail

cd ./src/bash

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR

ln -sv /usr/bin/bash $INITRAMFS_DIR/bin/bash
