#!/bin/bash
set -exuo pipefail

cd ./src
[ -d linux ] || (tar xf linux-*.tar.* && mv linux-*/ linux)
cd ./linux

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
