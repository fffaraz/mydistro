#!/bin/bash
set -exuo pipefail

cd ./src
tar xf gettext-*.tar.*
mv gettext-*/ gettext
cd ./gettext

./configure --disable-shared
make

cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

cd ..
rm -rf ./gettext
