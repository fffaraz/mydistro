#!/bin/bash
set -exuo pipefail

cd ./src/patch
cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
