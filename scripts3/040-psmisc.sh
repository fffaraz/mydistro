#!/bin/bash
set -exuo pipefail

cd ./src
tar xf psmisc-*.tar.*
mv psmisc-*/ psmisc
cd ./psmisc

./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./psmisc
