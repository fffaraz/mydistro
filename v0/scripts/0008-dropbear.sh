#!/bin/bash

cd /opt/mydistro/src/dropbear
./configure --enable-static
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
