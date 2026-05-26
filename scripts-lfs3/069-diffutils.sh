#!/bin/bash
set -exuo pipefail

cd ./src
tar xf diffutils-*.tar.*
mv diffutils-*/ diffutils
cd ./diffutils

./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./diffutils
