#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gperf-*.tar.*
mv gperf-*/ gperf
cd ./gperf

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3

make
make check || true
make install

cd ..
rm -rf ./gperf
