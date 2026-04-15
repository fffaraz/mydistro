#!/bin/bash

# compile curl
cd ./src/curl

autoreconf -vif

./configure --without-libpsl --without-brotli --with-openssl

make

# make install DESTDIR=/opt/mydistro/initramfs-dir

install -Dm755 src/curl /opt/mydistro/initramfs-dir/usr/local/bin/curl
install -Dm755 scripts/wcurl /opt/mydistro/initramfs-dir/usr/local/bin/wcurl
