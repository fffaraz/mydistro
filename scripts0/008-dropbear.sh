#!/bin/bash

# compile dropbear ssh server
cd ./src/dropbear

./configure --enable-static --mandir=/tmp/dropbear-man

make
make install DESTDIR=/opt/mydistro/initramfs-dir
