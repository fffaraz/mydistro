#!/bin/bash
set -exuo pipefail

cd ./src
tar xf packaging-*.tar.*
mv packaging-*/ packaging
cd ./packaging

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist packaging

cd ..
rm -rf ./packaging
