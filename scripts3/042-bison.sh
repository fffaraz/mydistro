#!/bin/bash
set -exuo pipefail

cd ./src
tar xf bison-*.tar.*
mv bison-*/ bison
cd ./bison

./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2

make
make check || true
make install

cd ..
rm -rf ./bison
