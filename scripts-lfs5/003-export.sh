#!/usr/bin/bash
set -exuo pipefail

rm -f ./output/stage6.tar.gz
tar \
	--exclude=/.dockerenv \
	--exclude=/dev \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/opt/mydistro \
	-czf ./output/stage6.tar.gz /

rm -f ./output/initramfs.cpio
find / \
	-path /.dockerenv -prune -o \
	-path /dev -prune -o \
	-path /proc -prune -o \
	-path /sys -prune -o \
	-path /opt/mydistro -prune -o \
	-print | cpio -o -H newc >./output/initramfs.cpio

gzip -f ./output/initramfs.cpio

cp /boot/vmlinuz-* ./output/bzImage
