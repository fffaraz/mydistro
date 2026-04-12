#!/bin/bash
set -exuo pipefail

cd ./src
[ -d gperf ] || (tar xf gperf-*.tar.* && mv gperf-*/ gperf)
cd ./gperf

ln -s ../gnulib ./gnulib

./autogen.sh

./configure --prefix=/usr \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) \
            --docdir=/usr/share/doc/gperf-3.3
make
make DESTDIR=$LFS install
