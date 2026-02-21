#!/bin/bash
set -exuo pipefail

mkdir -pv $LFS
cd $LFS

mkdir -p bin boot/efi dev etc/init.d home lib lib64 mnt opt proc root run srv sys tmp usr/local var
mkdir -p tools

ln -s $LFS/bin ./sbin
ln -s $LFS/bin ./usr/bin
ln -s $LFS/bin ./usr/sbin
ln -s $LFS/bin ./usr/local/bin
ln -s $LFS/bin ./usr/local/sbin

ln -s $LFS/lib ./usr/lib
ln -s $LFS/lib ./usr/local/lib
