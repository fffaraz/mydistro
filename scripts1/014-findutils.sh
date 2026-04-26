#!/bin/bash
set -exuo pipefail

cd ./src
tar xf findutils-*.tar.*
mv findutils-*/ findutils
cd ./findutils

./configure --prefix=/usr \
	--localstatedir=/var/lib/locate \
	--host=$LFS_TGT \
	--build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install
