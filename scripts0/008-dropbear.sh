#!/bin/bash

# compile dropbear ssh server
cd ./src/dropbear

./configure --mandir=/tmp/dropbear-man

make
make install DESTDIR=/opt/mydistro/initramfs-dir
