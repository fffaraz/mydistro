#!/bin/bash

# compile dropbear ssh server
cd ./src/dropbear

./configure --enable-static
make
make install DESTDIR=/opt/mydistro/initramfs-dir
