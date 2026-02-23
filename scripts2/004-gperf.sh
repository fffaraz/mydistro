#!/bin/bash
set -exuo pipefail

cd ./src/gperf

ln -s ../gnulib ./gnulib

./autogen.sh

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3
make
make install
