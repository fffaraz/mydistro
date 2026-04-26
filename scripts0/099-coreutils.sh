#!/bin/bash
set -exuo pipefail

cd ./src/coreutils

cp -r --reflink=auto ../gnulib ./gnulib-repo
rm ./gl/top/maint.mk.diff
./bootstrap --skip-po --gnulib-srcdir=./gnulib-repo
