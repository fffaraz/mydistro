#!/bin/bash
set -exuo pipefail

cd ./src
tar xf iana-etc-*.tar.*
mv iana-etc-*/ iana-etc
cd ./iana-etc

cp -v services protocols /etc

cd ..
rm -rf ./iana-etc
