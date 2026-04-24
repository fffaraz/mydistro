#!/bin/bash
set -exuo pipefail

mkdir -pv $LFS
cd $LFS

mkdir -p \
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

mkdir tools
