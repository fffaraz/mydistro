#!/bin/bash

cd buildroot

export BR2_EXTERNAL=..

make menuconfig
make xconfig

make savedefconfig
make linux-menuconfig
make uclibc-menuconfig

make mydistro_defconfig
make -j $(nproc)

make legal-info
