#!/bin/bash
set -exuo pipefail

cd ./src
tar xf jinja2-*.tar.*
mv jinja2-*/ jinja2
cd ./jinja2

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist Jinja2

cd ..
rm -rf ./jinja2
