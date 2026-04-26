#!/bin/bash
set -exuo pipefail

cd ./src/gawk
ln -sf "$(which aclocal)" /usr/local/bin/aclocal-1.16
ln -sf "$(which automake)" /usr/local/bin/automake-1.16
