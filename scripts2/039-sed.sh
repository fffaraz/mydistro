#!/bin/bash
set -exuo pipefail

cd ./src
tar xf sed-*.tar.*
mv sed-*/ sed
cd ./sed

./configure --prefix=/usr

make
make html

make check || true

make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9

cd ..
rm -rf ./sed
