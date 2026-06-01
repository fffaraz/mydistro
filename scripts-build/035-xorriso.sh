#!/usr/bin/bash
set -exuo pipefail

cd ./src
tar -xf xorriso.tar.gz
mv xorriso-*/ xorriso

cd ./xorriso

./configure --prefix=/usr

make

# Install into the next initramfs so pass 2's container has xorriso available
# from the start — 013-mkisofs.sh uses `xorriso -as mkisofs` to build the ISO,
# and pass 2 has no genisoimage from a debian base.
make install DESTDIR=$INITRAMFS_DIR

# Also install into the current container so 013-mkisofs.sh in this same pass
# can invoke xorriso.
make install
