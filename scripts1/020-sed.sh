#!/bin/bash
set -exuo pipefail

cd ./src
tar xf sed-*.tar.*
mv sed-*/ sed
cd ./sed

./configure --prefix=/usr \
	--host=$LFS_TGT \
	--build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install
