#!/usr/bin/bash
set -exuo pipefail

cd ./src/systemd

# Remove two unneeded groups (render, sgx) from the default udev rules so we
# don't have to create them — LFS does the same.
sed -e 's/GROUP="render"/GROUP="video"/' \
	-e 's/GROUP="sgx", //' \
	-i rules.d/50-udev-default.rules.in

rm -rf build
mkdir -p build
cd build

meson setup .. \
	--prefix=/usr \
	--buildtype=release \
	-D mode=release \
	-D default-dnssec=no \
	-D firstboot=false \
	-D install-tests=false \
	-D ldconfig=false \
	-D sysusers=false \
	-D rpmmacrosdir=no \
	-D homed=disabled \
	-D man=disabled \
	-D pamconfdir=no \
	-D dev-kvm-mode=0660 \
	-D nobody-group=nogroup \
	-D sysupdate=disabled \
	-D ukify=disabled \
	-D docdir=/usr/share/doc/systemd-260.2

ninja

DESTDIR=$INITRAMFS_DIR ninja install

ln -sv /usr/lib/systemd/systemd $INITRAMFS_DIR/init

touch $INITRAMFS_DIR/etc/machine-id

# Boot to a console, not the (nonexistent) graphical session that is the
# compiled-in default target.
ln -sfv /usr/lib/systemd/system/multi-user.target \
	$INITRAMFS_DIR/etc/systemd/system/default.target

# Enable a getty on tty1 for graphical/disk boots (run.sh --iso / --img).
# The serial getty for console=ttyS0 (run.sh --cli) is created automatically by
# systemd-getty-generator; and without dbus there's no logind autovt to spawn
# tty1 on demand, so enable it statically here.
mkdir -pv $INITRAMFS_DIR/etc/systemd/system/getty.target.wants
ln -sfv /usr/lib/systemd/system/getty@.service \
	$INITRAMFS_DIR/etc/systemd/system/getty.target.wants/getty@tty1.service
