#!/bin/bash
set -exuo pipefail

cd ./src
tar xf lz4-*.tar.*
mv lz4-*/ lz4
cd ./lz4

make BUILD_STATIC=no PREFIX=/usr
make -j1 check
make BUILD_STATIC=no PREFIX=/usr install

cd ..
rm -rf ./lz4
