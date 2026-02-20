#!/bin/bash

# compile nano editor
cd ./src/nano

# ln -s ../gnulib ./gnulib
cp -r --reflink=auto ../gnulib ./gnulib

./autogen.sh
./configure --enable-utf8 --enable-year2038 CFLAGS="-O3 -Wall --static"
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
