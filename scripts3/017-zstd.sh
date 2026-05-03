#!/bin/bash
set -exuo pipefail

cd ./src
tar xf zstd-*.tar.*
mv zstd-*/ zstd
cd ./zstd

make prefix=/usr
make check || true
make prefix=/usr install

rm -v /usr/lib/libzstd.a

cd ..
rm -rf ./zstd
