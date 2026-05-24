#!/bin/bash
set -exuo pipefail

cd ./src/gperf

# ln -sfn ../gnulib ./gnulib
cp -r --reflink=auto ../gnulib ./gnulib

./autogen.sh

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
