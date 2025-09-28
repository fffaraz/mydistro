#!/bin/bash

# compile nano editor

cd /opt/mydistro/src/nano

./autogen.sh
./configure
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
