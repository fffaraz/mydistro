#!/bin/bash

# compile curl
cd ./src/curl

autoreconf -vif

./configure \
	CFLAGS='-O3 -Wall --static' LDFLAGS='--static -static-libgcc' \
	--disable-shared --enable-static \
	--without-brotli --without-libpsl --without-ssl --without-zstd --without-zlib

make -j$(nproc)

# make install DESTDIR=/opt/mydistro/initramfs-dir

install -Dm755 src/curl /opt/mydistro/initramfs-dir/usr/local/bin/curl
install -Dm755 scripts/wcurl /opt/mydistro/initramfs-dir/usr/local/bin/wcurl
