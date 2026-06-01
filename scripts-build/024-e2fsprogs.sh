#!/bin/bash
set -exuo pipefail

cd ./src/e2fsprogs

mkdir -p build
cd build

# --disable-libblkid makes e2fsprogs link against the *external* libblkid
# instead of its bundled copy. That external lib is the one util-linux (023)
# just installed into $INITRAMFS_DIR, not anything in the build container, so
# point the compiler/linker there. (In pass 2 the container is mydistro itself
# and already ships libblkid in /usr, which is why this used to "just work".)
export CPPFLAGS="-I$INITRAMFS_DIR/usr/include ${CPPFLAGS:-}"
export LDFLAGS="-L$INITRAMFS_DIR/usr/lib ${LDFLAGS:-}"

../configure --prefix=/usr --sysconfdir=/etc --enable-elf-shlibs --disable-nls --disable-libblkid

make
make install DESTDIR=$INITRAMFS_DIR

rm -fv $INITRAMFS_DIR/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
