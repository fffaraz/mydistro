#!/bin/bash
set -exuo pipefail

cd ./src
tar xf less-*.tar.*
mv less-*/ less
cd ./less

./configure --prefix=/usr --sysconfdir=/etc

make
make check
make install

cd ..
rm -rf ./less
