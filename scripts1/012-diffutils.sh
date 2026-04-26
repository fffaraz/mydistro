#!/bin/bash
set -exuo pipefail

cd ./src
tar xf diffutils-*.tar.*
mv diffutils-*/ diffutils
cd ./diffutils

./configure --prefix=/usr \
	--host=$LFS_TGT \
	gl_cv_func_strcasecmp_works=y \
	--build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install

cd ..
rm -rf ./diffutils