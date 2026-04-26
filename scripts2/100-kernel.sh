#!/bin/bash
set -exuo pipefail

cd ./src
tar xf linux-*.tar.*
mv linux-*/ linux
cd ./linux

make mrproper

# Provide a kernel config; either copy one from assets or run `make menuconfig` interactively.
if [ -f ../../assets/kernel.config ]; then
	cp -v ../../assets/kernel.config .config
	make olddefconfig
else
	# make menuconfig  # interactive; run manually if no preconfigured .config
	make defconfig
fi

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
