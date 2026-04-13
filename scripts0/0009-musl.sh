#!/bin/bash

# compile musl
cd ./src/musl

./configure
make
make install DESTDIR=/opt/mydistro/initramfs-dir
