#!/bin/bash
set -exuo pipefail

cd ./src
tar xf bc-*.tar.*
mv bc-*/ bc
cd ./bc

CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r

make
make test
make install

cd ..
rm -rf ./bc
