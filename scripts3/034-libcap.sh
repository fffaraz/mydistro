#!/bin/bash
set -exuo pipefail

cd ./src
tar xf libcap-*.tar.*
mv libcap-*/ libcap
cd ./libcap

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib
make test
make prefix=/usr lib=lib install

cd ..
rm -rf ./libcap
