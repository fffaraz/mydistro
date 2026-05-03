#!/bin/bash
set -exuo pipefail

cd ./src
tar xf findutils-*.tar.*
mv findutils-*/ findutils
cd ./findutils

./configure --prefix=/usr --localstatedir=/var/lib/locate

make
make install

cd ..
rm -rf ./findutils
