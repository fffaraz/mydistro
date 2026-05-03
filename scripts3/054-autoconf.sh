#!/bin/bash
set -exuo pipefail

cd ./src
tar xf autoconf-*.tar.*
mv autoconf-*/ autoconf
cd ./autoconf

./configure --prefix=/usr
make
make check || true
make install

cd ..
rm -rf ./autoconf
