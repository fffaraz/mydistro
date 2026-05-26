#!/bin/bash
set -exuo pipefail

cd ./src
tar xf XML-Parser-*.tar.*
mv XML-Parser-*/ xml-parser
cd ./xml-parser

perl Makefile.PL

make
make test
make install

cd ..
rm -rf ./xml-parser
