#!/bin/bash

# compile glibc
cd ./src/glibc

mkdir build
cd build

../configure --prefix /opt/mydistro/initramfs-dir/usr/local/glibc
make -j$(nproc)

# make install
