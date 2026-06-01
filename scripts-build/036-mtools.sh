#!/usr/bin/bash
set -exuo pipefail

cd ./src/mtools

# salsa.debian.org's upstream/ branches mirror the upstream tarball, which
# ships ./configure. If it's missing (e.g. a future branch layout change),
# regenerate it from autotools.
[ -x ./configure ] || autoreconf -fi

./configure --prefix=/usr --sysconfdir=/etc

make

# Install into the next initramfs so pass 2's container has mcopy/mformat from
# the start, and into the current container so anything later in this pass can
# use them too.
make install DESTDIR=$INITRAMFS_DIR
make install
