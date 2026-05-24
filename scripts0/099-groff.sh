#!/bin/bash
set -exuo pipefail

cd ./src/groff

./bootstrap

PAGE=letter ./configure --prefix=/usr

# xpmtoppm (netpbm) isn't in the distro yet, so bypass the rule that
# regenerates this example doc image from doc/gnu.xpm.
mkdir -p doc
: >doc/gnu.eps
touch -d '2099-01-01' doc/gnu.eps

make
make install DESTDIR=$INITRAMFS_DIR
