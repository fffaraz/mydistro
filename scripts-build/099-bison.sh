#!/usr/bin/bash
set -exuo pipefail

cd ./src/bison

# git-version-gen needs either a working `git describe` or .tarball-version.
# Pass 2 has neither (no git binary in initramfs; shallow clone .git survives
# the overlay but git itself doesn't), so seed the version explicitly.
echo 3.8.2 >.tarball-version

./bootstrap --skip-po --no-git --gnulib-srcdir=./gnulib

# sed -i '/\/\* directory \*\/ NULL,/a\ NULL,' src/output.c src/print-xml.c

./configure --disable-nls --disable-shared

make
make install DESTDIR=$INITRAMFS_DIR
