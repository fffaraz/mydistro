#!/bin/bash
set -exuo pipefail

cd ./src
tar -xf gperf.tar.gz
cd gperf-3.3

# ln -sfn ../gnulib ./gnulib
# cp -r --reflink=auto ../gnulib ./gnulib

# ./autogen.sh

./configure --prefix=/usr

make
make install DESTDIR=$INITRAMFS_DIR
