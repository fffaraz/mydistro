#!/bin/bash
set -exuo pipefail

cd ./src
tar xf linux-*.tar.*
mv linux-*/ linux
cd ./linux

make mrproper

make defconfig

# General setup
./scripts/config --disable WERROR
./scripts/config --enable  PSI
./scripts/config --disable PSI_DEFAULT_DISABLED
./scripts/config --disable IKHEADERS
./scripts/config --enable  CGROUPS
./scripts/config --enable  MEMCG
./scripts/config --enable  CGROUP_SCHED
./scripts/config --disable RT_GROUP_SCHED
./scripts/config --disable EXPERT

# Processor type and features
./scripts/config --enable  RELOCATABLE
./scripts/config --enable  RANDOMIZE_BASE

# General architecture-dependent options
./scripts/config --enable  STACKPROTECTOR
./scripts/config --enable  STACKPROTECTOR_STRONG

# Networking
./scripts/config --enable  NET
./scripts/config --enable  INET
./scripts/config --enable  IPV6

# Device Drivers — generic + firmware + framebuffer + DRM
./scripts/config --disable UEVENT_HELPER
./scripts/config --enable  DEVTMPFS
./scripts/config --enable  DEVTMPFS_MOUNT
./scripts/config --enable  FW_LOADER
./scripts/config --disable FW_LOADER_USER_HELPER
./scripts/config --enable  DMIID
./scripts/config --enable  SYSFB_SIMPLEFB
./scripts/config --enable  DRM
./scripts/config --enable  DRM_PANIC
./scripts/config --set-str DRM_PANIC_SCREEN kmsg
./scripts/config --enable  DRM_FBDEV_EMULATION
./scripts/config --enable  DRM_SIMPLEDRM
./scripts/config --enable  FRAMEBUFFER_CONSOLE

# File systems
./scripts/config --enable  INOTIFY_USER
./scripts/config --enable  TMPFS
./scripts/config --enable  TMPFS_POSIX_ACL

# 64-bit additions (x86_64)
./scripts/config --enable  X86_X2APIC
./scripts/config --enable  PCI
./scripts/config --enable  PCI_MSI
./scripts/config --enable  IOMMU_SUPPORT
./scripts/config --enable  IRQ_REMAP

# NVMe block device (needed if root is on /dev/nvme*)
./scripts/config --enable  BLK_DEV_NVME

make olddefconfig

make
make modules_install

cp -iv arch/x86/boot/bzImage /boot/vmlinuz-6.18.10-lfs-13.0-systemd
cp -iv System.map /boot/System.map-6.18.10
cp -iv .config /boot/config-6.18.10

cp -r Documentation -T /usr/share/doc/linux-6.18.10

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd $CMDLINE_OPTS
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd $CMDLINE_OPTS

# End /etc/modprobe.d/usb.conf
EOF

cd ../..
rm -rf ./linux
