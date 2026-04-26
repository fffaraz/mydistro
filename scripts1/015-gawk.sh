#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gawk-*.tar.*
mv gawk-*/ gawk
cd ./gawk

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
