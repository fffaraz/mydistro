#!/bin/bash
set -exuo pipefail

cd ./src/gettext

./autogen.sh
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
