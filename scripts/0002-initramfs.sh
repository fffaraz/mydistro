#!/bin/bash
set -exuo pipefail

# initialize initramfs directory structure
mkdir -p ./initramfs-dir

cd ./initramfs-dir
mkdir -p bin boot/efi etc/init.d home lib lib64 mnt proc sys tmp opt usr/local var
mkdir -p tools

ROOT_DIR=/opt/mydistro/initramfs-dir

ln -s $ROOT_DIR/bin ./sbin
ln -s $ROOT_DIR/bin ./usr/bin
ln -s $ROOT_DIR/bin ./usr/sbin
ln -s $ROOT_DIR/bin ./usr/local/bin
ln -s $ROOT_DIR/bin ./usr/local/sbin

ln -s $ROOT_DIR/lib ./usr/lib
ln -s $ROOT_DIR/lib ./usr/local/lib

touch ./etc/fstab
