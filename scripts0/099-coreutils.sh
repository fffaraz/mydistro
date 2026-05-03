#!/bin/bash
set -exuo pipefail

cd ./src/coreutils

./bootstrap --skip-po 

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-install-program=hostname --enable-no-install-program=kill,uptime --disable-nls

# grep -q '^#include <string.h>' lib/mbbuf.h || sed -i '/^#include "idx.h"/a #include <string.h>' lib/mbbuf.h

make
make install DESTDIR=$INITRAMFS_DIR
