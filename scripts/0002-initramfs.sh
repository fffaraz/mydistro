#!/bin/bash
set -x

# initialize initramfs directory structure
mkdir -p ./initramfs-dir
mkdir -p ./tools

cd ./initramfs-dir
mkdir -p bin etc/init.d home lib lib64 mnt proc sys tmp usr/local var

ROOT_DIR=/opt/mydistro/initramfs-dir

ln -s $ROOT_DIR/bin ./sbin
ln -s $ROOT_DIR/bin ./usr/bin
ln -s $ROOT_DIR/bin ./usr/sbin
ln -s $ROOT_DIR/bin ./usr/local/bin
ln -s $ROOT_DIR/bin ./usr/local/sbin

ln -s $ROOT_DIR/lib ./usr/lib
ln -s $ROOT_DIR/lib ./usr/local/lib

touch ./etc/fstab
