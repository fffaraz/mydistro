#!/usr/bin/bash
set -exuo pipefail

# initialize initramfs directory structure
mkdir -p ./initramfs-dir

cd ./initramfs-dir
mkdir -p \
	bin \
	boot/efi \
	dev \
	etc/init.d \
	home \
	lib \
	lib64 \
	mnt \
	opt \
	proc \
	root \
	run \
	sbin \
	srv \
	sys \
	tmp \
	usr/bin \
	usr/lib \
	usr/libexec \
	usr/local/bin \
	usr/local/lib \
	usr/local/sbin \
	usr/sbin \
	var/log

# /tmp must be world-writable + sticky (mode 1777); some tools (e.g. syslinux's
# linux installer) refuse to run otherwise. mkdir -p uses umask, which gives 0755.
chmod 1777 ./tmp
