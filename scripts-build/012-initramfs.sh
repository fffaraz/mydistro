#!/usr/bin/bash
set -exuo pipefail

cp ./assets/etc/passwd ./initramfs-dir/etc/passwd
cp ./assets/etc/group ./initramfs-dir/etc/group
cp ./assets/etc/hostname ./initramfs-dir/etc/hostname
cp ./assets/etc/hosts ./initramfs-dir/etc/hosts
cp ./assets/etc/os-release ./initramfs-dir/etc/os-release
cp ./assets/etc/profile ./initramfs-dir/etc/profile
cp ./assets/etc/resolv.conf ./initramfs-dir/etc/resolv.conf
cp ./src/busybox/examples/inittab ./initramfs-dir/etc/inittab

cp ./assets/etc/init.d/rcS ./initramfs-dir/etc/init.d/rcS
chmod +x ./initramfs-dir/etc/init.d/rcS

touch ./initramfs-dir/etc/fstab

ln -sv /sbin/init ./initramfs-dir/init
ln -sv /proc/self/mounts ./initramfs-dir/etc/mtab

mkdir -p ./initramfs-dir/etc/ssl/certs
cp ./src/cacert.pem ./initramfs-dir/etc/ssl/certs/ca-certificates.crt

# large dummy file
# dd if=/dev/zero of=./initramfs-dir/largefile bs=1M count=128

# Rebuild /etc/ld.so.cache. 009-glibc.sh's `make install` already ran ldconfig once,
# but that snapshot predates the 099-* libs (liblzma, libncurses, libbash, ...).
# Pass 2's upstream ld.so only falls back to /lib64 and /usr/lib64, so anything
# in /usr/lib that's not cached (e.g. liblzma.so.5) is unfindable at runtime.
"$INITRAMFS_DIR/sbin/ldconfig" -r "$INITRAMFS_DIR"

cd ./initramfs-dir

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
