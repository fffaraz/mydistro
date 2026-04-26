#!/bin/bash
set -exuo pipefail

cd ./src
tar xf libpipeline-*.tar.*
mv libpipeline-*/ libpipeline
cd ./libpipeline

./configure --prefix=/usr

make
make install

cd ..
rm -rf ./libpipeline
