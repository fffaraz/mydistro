#!/bin/bash
set -exuo pipefail

# initialize initramfs directory structure
mkdir -p ./initramfs-dir

cd ./initramfs-dir
mkdir -p boot/efi dev etc/init.d home lib64 mnt opt proc root run srv sys tmp usr/bin usr/lib usr/libexec usr/local var
mkdir -p tools

ROOT_DIR=/opt/mydistro/initramfs-dir

ln -s $ROOT_DIR/usr/bin ./bin
ln -s $ROOT_DIR/usr/bin ./sbin
ln -s $ROOT_DIR/usr/bin ./usr/sbin
ln -s $ROOT_DIR/usr/bin ./usr/local/bin
ln -s $ROOT_DIR/usr/bin ./usr/local/sbin

ln -s $ROOT_DIR/usr/lib ./lib
ln -s $ROOT_DIR/usr/lib ./usr/local/lib
