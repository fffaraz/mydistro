#!/bin/bash
set -exuo pipefail

cd ./src/gperf

ln -s ../gnulib ./gnulib
./autogen.sh
