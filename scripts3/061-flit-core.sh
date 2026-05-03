#!/bin/bash
set -exuo pipefail

cd ./src
tar xf flit_core-*.tar.*
mv flit_core-*/ flit-core
cd ./flit-core

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist flit_core

cd ..
rm -rf ./flit-core
