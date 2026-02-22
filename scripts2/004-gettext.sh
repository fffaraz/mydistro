#!/bin/bash
set -exuo pipefail

cd ./src/gettext

rmdir ./gnulib
ln -s ../gnulib gnulib

sed -i "/emit += 'AM_CFLAGS %s.*am_set_or_augment/i\\        emit += 'AM_CFLAGS =\\\\n'" gnulib-repo/pygnulib/GLEmiter.py

./autogen.sh
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
