#!/bin/bash
set -exuo pipefail

cd ./rootfs

rmdir ./lib
ln -sv /usr/lib ./lib

tar -czvf ../output/bootstrap.tar.gz .
