#!/bin/bash
set -exuo pipefail

cd ./src
tar xf file-*.tar.*
mv file-*/ file
cd ./file

./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./file
