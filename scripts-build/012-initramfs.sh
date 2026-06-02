#!/usr/bin/bash
set -exuo pipefail

cp ./assets/etc/passwd $INITRAMFS_DIR/etc/passwd
cp ./assets/etc/group $INITRAMFS_DIR/etc/group
cp ./assets/etc/hostname $INITRAMFS_DIR/etc/hostname
cp ./assets/etc/hosts $INITRAMFS_DIR/etc/hosts
cp ./assets/etc/os-release $INITRAMFS_DIR/etc/os-release
cp ./assets/etc/profile $INITRAMFS_DIR/etc/profile
cp ./assets/etc/resolv.conf $INITRAMFS_DIR/etc/resolv.conf

touch $INITRAMFS_DIR/etc/fstab

ln -sv /proc/self/mounts $INITRAMFS_DIR/etc/mtab

# large dummy file
# dd if=/dev/zero of=$INITRAMFS_DIR/largefile bs=1M count=128

# Rebuild /etc/ld.so.cache. 009-glibc.sh's `make install` already ran ldconfig once,
# but that snapshot predates the 099-* libs (liblzma, libncurses, libbash, ...).
# Pass 2's upstream ld.so only falls back to /lib64 and /usr/lib64, so anything
# in /usr/lib that's not cached (e.g. liblzma.so.5) is unfindable at runtime.
"$INITRAMFS_DIR/sbin/ldconfig" -r "$INITRAMFS_DIR"

cd $INITRAMFS_DIR

# remove unnecessary files
rm -rf ./tmp/*

# strip all binaries
find ./usr/bin -type f -exec strip --strip-all {} + 2>/dev/null || true

# create initramfs.cpio
find . | cpio -o -H newc >../output/initramfs.cpio
# -o, --create
# -H, --format=

# create initramfs.cpio.gz
gzip -f ../output/initramfs.cpio

# create initramfs.tar.gz
tar -czvf ../output/initramfs.tar.gz .
