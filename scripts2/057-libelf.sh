#!/bin/bash
set -exuo pipefail

cd ./src
tar xf elfutils-*.tar.*
mv elfutils-*/ libelf
cd ./libelf

./configure --prefix=/usr \
	--disable-debuginfod \
	--enable-libdebuginfod=dummy

make -C lib
make -C libelf

make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

cd ..
rm -rf ./libelf
