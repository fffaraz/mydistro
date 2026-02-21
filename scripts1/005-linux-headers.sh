#!/bin/bash
set -exuo pipefail

cd ./src/linux

make mrproper

make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
