#!/bin/bash
set -exuo pipefail

cd ./src
tar xf make-*.tar.*
mv make-*/ make
cd ./make

./configure --prefix=/usr

make
make install

cd ..
rm -rf ./make
