#!/bin/bash
set -exuo pipefail

cd ./src
tar xf bash-*.tar.*
mv bash-*/ bash
cd ./bash

./configure --prefix=/usr \
	--build=$(sh support/config.guess) \
	--host=$LFS_TGT \
	--without-bash-malloc

make
make DESTDIR=$LFS install

ln -sv /usr/bin/bash $LFS/bin/sh
ln -sv /usr/bin/bash $LFS/bin/bash # not in the book, but I want it

cd ..
rm -rf ./bash
