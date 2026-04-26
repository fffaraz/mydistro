#!/bin/bash
set -exuo pipefail

cd ./src
tar xf autoconf-*.tar.*
mv autoconf-*/ autoconf
cd ./autoconf

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install
