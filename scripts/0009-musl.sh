#!/bin/bash

# compile musl

cd /opt/mydistro/src/musl

./configure
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
