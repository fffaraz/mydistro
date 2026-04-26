#!/bin/bash
set -exuo pipefail

cd ./src
tar xf grep-*.tar.*
mv grep-*/ grep
cd ./grep

sed -i "s/echo/#echo/" src/egrep.sh

./configure --prefix=/usr

make
make check
make install

cd ..
rm -rf ./grep
