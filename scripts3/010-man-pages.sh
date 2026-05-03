#!/bin/bash
set -exuo pipefail

cd ./src
tar xf man-pages-*.tar.*
mv man-pages-*/ man-pages
cd ./man-pages

rm -v man3/crypt*
make -R GIT=false prefix=/usr install

cd ..
rm -rf ./man-pages
