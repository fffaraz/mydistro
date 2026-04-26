#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gdbm-*.tar.*
mv gdbm-*/ gdbm
cd ./gdbm

./configure --prefix=/usr \
	--disable-static \
	--enable-libgdbm-compat

make
make check
make install

cd ..
rm -rf ./gdbm
