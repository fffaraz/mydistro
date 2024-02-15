FROM debian:sid-slim

# install dependencies
RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq curl debootstrap genisoimage git isolinux live-build nano plocate squashfs-tools syslinux wget xorriso zstd

# debootstrap --variant=minbase
RUN \
	mkdir -p /opt/mydistro/rootfs && \
	cd /opt/mydistro && \
	debootstrap --arch=amd64 \
		--include linux-image-amd64,linux-headers-amd64,live-boot,curl,ncdu,plocate,wget,locales,sudo,vim,nano,build-essential,dkms,htop,zstd \
		sid rootfs http://deb.debian.org/debian/

# chroot
RUN \
	echo "myhostname" > /opt/mydistro/rootfs/etc/hostname && \
	echo "deb http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware" > /opt/mydistro/rootfs/etc/apt/sources.list && \
	mkdir -p /opt/mydistro/rootfs/etc/lightdm/lightdm.conf.d && \
	echo "[SeatDefaults]\nautologin-user=root" > /opt/mydistro/rootfs/etc/lightdm/lightdm.conf.d/12-autologin.conf && \
	chroot /opt/mydistro/rootfs apt update && \
	chroot /opt/mydistro/rootfs apt install -yq \
		xorg xinit xfce4 xfce4-goodies lightdm xserver-xorg-video-vesa dbus-x11 pulseaudio \
		firmware-linux intel-microcode amd64-microcode virtualbox-guest-x11 virtualbox-guest-utils firefox && \
	chroot /opt/mydistro/rootfs systemctl --user enable pulseaudio && \
	echo 'root:root' | chroot /opt/mydistro/rootfs chpasswd && \
	chroot /opt/mydistro/rootfs apt-get clean && \
	rm -rf /opt/mydistro/rootfs/var/lib/apt/lists/* /opt/mydistro/rootfs/var/log/* /opt/mydistro/rootfs/tmp/*

# squashfs
RUN \
	mkdir -p /opt/mydistro/binary/live && \
	cp /opt/mydistro/rootfs/vmlinuz /opt/mydistro/binary/live/vmlinuz && \
	cp /opt/mydistro/rootfs/initrd.img /opt/mydistro/binary/live/initrd && \
	mksquashfs /opt/mydistro/rootfs /opt/mydistro/binary/live/filesystem.squashfs -comp xz -e boot

# isolinux
RUN \
	mkdir -p /opt/mydistro/binary/isolinux && \
	cp /usr/lib/ISOLINUX/isolinux.bin /opt/mydistro/binary/isolinux && \
	cp /usr/lib/syslinux/modules/bios/ldlinux.c32 /opt/mydistro/binary/isolinux && \
	cp /usr/lib/syslinux/modules/bios/libutil.c32 /opt/mydistro/binary/isolinux && \
	cp /usr/lib/syslinux/modules/bios/libcom32.c32 /opt/mydistro/binary/isolinux && \
	cp /usr/lib/syslinux/modules/bios/vesamenu.c32 /opt/mydistro/binary/isolinux && \
	cp /usr/lib/syslinux/modules/bios/menu.c32 /opt/mydistro/binary/isolinux
ADD isolinux.cfg /opt/mydistro/binary/isolinux/isolinux.cfg

# create iso
RUN \
	cd /opt/mydistro && \
	xorriso -as mkisofs -r -J -joliet-long -l -cache-inodes -partition_offset 16 -A "Debian Live" -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o remaster.iso binary && \
	mkisofs -J -R -o mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table binary

WORKDIR /opt/mydistro
