#!/bin/bash
set -exuo pipefail

cd ./src
tar xf markupsafe-*.tar.*
mv markupsafe-*/ markupsafe
cd ./markupsafe

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist Markupsafe

cd ..
rm -rf ./markupsafe
