#!/bin/bash
set -exuo pipefail

cd ./rootfs

rmdir ./lib
ln -sv /usr/lib ./lib

rm -f ../output/bootstrap.tar.gz
tar -czvf ../output/bootstrap.tar.gz .
