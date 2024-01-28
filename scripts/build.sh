#!/bin/bash

cd buildroot

export BR2_EXTERNAL=..

BR2_EXTERNAL=.. make mydistro_defconfig

# BR2_EXTERNAL=.. make menuconfig
# BR2_EXTERNAL=.. make xconfig
# BR2_EXTERNAL=.. make savedefconfig

# BR2_EXTERNAL=.. make linux-menuconfig
# BR2_EXTERNAL=.. make linux-xconfig
# BR2_EXTERNAL=.. make linux-update-config # to save a full config file
# BR2_EXTERNAL=.. make linux-update-defconfig #  to save a minimal defconfig

# BR2_EXTERNAL=.. make uclibc-menuconfig

BR2_EXTERNAL=.. make -j $(nproc)

BR2_EXTERNAL=.. make legal-info
