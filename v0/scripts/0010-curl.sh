#!/bin/bash

# compile curl

cd /opt/mydistro/src/curl
autoreconf -vif

./configure \
	CFLAGS='-static' LDFLAGS='-static -static-libgcc' \
	--disable-shared --enable-static \
	--without-brotli --without-libpsl --without-ssl --without-zstd --without-zlib

make -j$(nproc)
make install DESTDIR=/opt/mydistro/initramfs-dir
