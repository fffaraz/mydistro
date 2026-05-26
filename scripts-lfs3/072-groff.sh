#!/bin/bash
set -exuo pipefail

cd ./src
tar xf groff-*.tar.*
mv groff-*/ groff
cd ./groff

PAGE=letter ./configure --prefix=/usr

make
make check || true
make install

cd ..
rm -rf ./groff
