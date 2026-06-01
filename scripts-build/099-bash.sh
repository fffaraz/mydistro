#!/bin/bash
set -exuo pipefail

cd ./src/bash

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
