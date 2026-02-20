#!/bin/bash
set -exuo pipefail

cd ./src/gzip

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install
