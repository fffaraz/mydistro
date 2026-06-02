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
