#!/bin/bash
set -exuo pipefail

cd ./src
tar xf patch-*.tar.*
mv patch-*/ patch
cd ./patch

./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./patch
