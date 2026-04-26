#!/bin/bash
set -exuo pipefail

cd ./src
tar xf m4-*.tar.*
mv m4-*/ m4
cd ./m4

./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./m4
