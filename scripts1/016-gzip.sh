#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gzip-*.tar.*
mv gzip-*/ gzip
cd ./gzip

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

cd ..
rm -rf ./gzip
