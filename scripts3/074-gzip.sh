#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gzip-*.tar.*
mv gzip-*/ gzip
cd ./gzip

./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./gzip
