#!/bin/bash
set -exuo pipefail

cd ./src
tar xf openssl-*.tar.*
mv openssl-*/ openssl
cd ./openssl

./config --prefix=/usr \
	--openssldir=/etc/ssl \
	--libdir=lib \
	shared \
	zlib-dynamic

make
HARNESS_JOBS=$(nproc) make test || true

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.6.1
cp -vfr doc/* /usr/share/doc/openssl-3.6.1

cd ..
rm -rf ./openssl
