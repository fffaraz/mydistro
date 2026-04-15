#!/bin/bash
set -exuo pipefail

# initialize initramfs directory structure
mkdir -p ./initramfs-dir

cd ./initramfs-dir
mkdir -p bin boot/efi dev etc/init.d home lib lib64 mnt opt proc root run sbin srv sys tmp usr/bin usr/sbin usr/lib usr/libexec usr/local/bin usr/local/sbin usr/local/lib var

ROOT_DIR=/opt/mydistro/initramfs-dir
