#!/bin/bash
set -exuo pipefail

cd ./src
tar xf libxcrypt-*.tar.*
mv libxcrypt-*/ libxcrypt
cd ./libxcrypt

sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c

./configure --prefix=/usr \
	--enable-hashes=strong,glibc \
	--enable-obsolete-api=no \
	--disable-static \
	--disable-failure-tokens

make
make check
make install

cd ..
rm -rf ./libxcrypt
