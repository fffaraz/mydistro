#!/bin/bash
set -exuo pipefail

cd ./src
tar xf automake-*.tar.*
mv automake-*/ automake
cd ./automake

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1
make
make check || true
make install

cd ..
rm -rf ./automake
