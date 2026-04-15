#!/bin/bash
set -exuo pipefail

cd ./src/zstd

make
make install DESTDIR=/opt/mydistro/initramfs-dir
