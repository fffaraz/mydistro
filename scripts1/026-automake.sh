#!/bin/bash
set -exuo pipefail

cd ./src/automake

./bootstrap
./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
