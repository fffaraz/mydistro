#!/bin/bash

cd /opt/mydistro/src/glibc
mkdir build
cd build

../configure --prefix /opt/mydistro/initramfs-dir/usr/local/glibc
make -j$(nproc)

# make install
