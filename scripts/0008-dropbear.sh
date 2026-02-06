#!/bin/bash

# compile dropbear ssh server

cd ./src/dropbear
./configure --enable-static
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
