#!/bin/bash
set -exuo pipefail

cd ./src
if [ ! -d automake ]; then
	tar xf automake-*.tar.*
	mv automake-*/ automake
	cd ./automake
else
	cd ./automake
	./bootstrap
fi

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
