#!/bin/bash
set -exuo pipefail

cd ./rootfs

rmdir ./lib
ln -sv /usr/lib ./lib

rm -f ../output/stage2.tar.gz
tar -czvf ../output/stage2.tar.gz .
