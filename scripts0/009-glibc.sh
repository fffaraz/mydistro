#!/bin/bash

cd ./src/glibc

mkdir build
cd build

../configure

make
make install DESTDIR=/opt/mydistro/initramfs-dir
