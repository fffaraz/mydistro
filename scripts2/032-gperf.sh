#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gperf-*.tar.*
mv gperf-*/ gperf
cd ./gperf

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess) \
	--docdir=/usr/share/doc/gperf-3.3

make LDFLAGS="-static-libgcc -static-libstdc++"
make DESTDIR=$LFS install

cd ..
rm -rf ./gperf
