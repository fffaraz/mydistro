#!/bin/bash
set -exuo pipefail

cd ./src
tar xf texinfo-*.tar.*
mv texinfo-*/ texinfo
cd ./texinfo

./configure --prefix=/usr
make
make install
