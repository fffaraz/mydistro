#!/bin/bash
set -exuo pipefail

cd ./src/bison

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install
