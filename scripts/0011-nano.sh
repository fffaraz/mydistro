#!/bin/bash

# compile nano editor

cd /opt/mydistro/src/nano

./autogen.sh
./configure --enable-utf8 --enable-year2038 CFLAGS="-O3 -Wall --static"
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
