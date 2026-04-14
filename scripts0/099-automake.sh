#!/bin/bash
set -exuo pipefail

cd ./src/automake
./bootstrap

./configure
make
make install DESTDIR=/opt/mydistro/initramfs-dir
