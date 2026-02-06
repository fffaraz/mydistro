#!/bin/bash

# compile musl
cd ./src/musl

./configure
make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
