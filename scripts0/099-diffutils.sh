#!/bin/bash
set -exuo pipefail

cd ./src/diffutils
cp -r --reflink=auto ../gnulib ./gnulib-repo
sed -i "/emit += 'AM_CFLAGS %s.*am_set_or_augment/i\\        emit += 'AM_CFLAGS =\\\\n'" gnulib-repo/pygnulib/GLEmiter.py
./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib-repo
