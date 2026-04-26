#!/bin/bash
set -exuo pipefail

cd ./src/grep
cp -r --reflink=auto ../gnulib ./gnulib-repo
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
