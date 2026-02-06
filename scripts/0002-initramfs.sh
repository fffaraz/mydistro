#!/bin/bash
set -x

mkdir -p ./initramfs-dir

cd ./initramfs-dir
mkdir -p etc/init.d proc sys tmp home mnt usr/lib var
