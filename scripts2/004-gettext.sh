#!/bin/bash
set -exuo pipefail

cd ./src/gettext

rmdir ./gnulib
ln -s ../gnulib gnulib

./autogen.sh
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
