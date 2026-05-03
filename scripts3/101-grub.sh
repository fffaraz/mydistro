#!/bin/bash
set -exuo pipefail

# Site-specific: replace /dev/sdX with the actual install disk before running grub-install.
# grub-install /dev/sdX

mkdir -pv /boot/grub
cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 6.18.10-lfs-13.0-systemd" {
        linux   /boot/vmlinuz-6.18.10-lfs-13.0-systemd root=/dev/sda2 ro
}
EOF
