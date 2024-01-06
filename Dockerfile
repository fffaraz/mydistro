FROM debian:sid-slim

# install dependencies
RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq nano build-essential bzip2 git vim make gcc \
		libncurses-dev flex bison bc cpio libelf-dev libssl-dev syslinux \
		dosfstools genisoimage wget curl nasm python3 python-is-python3 \
		unzip uuid-dev upx-ucl pkg-config

# download source code
RUN \
	mkdir -p /opt/mydistro/initramfs && \
	mkdir -p /opt/mydistro/myiso/isolinux && \
	cd /opt/mydistro && \
	git clone --depth 1 https://github.com/torvalds/linux.git && \
	git clone --depth 1 https://git.busybox.net/busybox && \
	git clone --depth 1 https://salsa.debian.org/images-team/syslinux.git && \
	git clone --depth 1 https://github.com/memtest86plus/memtest86plus.git && \
	git clone --depth 1 https://github.com/mkj/dropbear.git

# compile kernel
# ADD linux.config /opt/mydistro/linux/.config
RUN \
	cd /opt/mydistro/linux && \
	make defconfig && \
	make -j$(nproc) && \
	cp ./arch/x86/boot/bzImage /opt/mydistro/myiso

# compile busybox
# ADD busybox.config /opt/mydistro/busybox/.config
RUN \
	cd /opt/mydistro/busybox && \
	make defconfig && \
	echo "CONFIG_STATIC=y" >> .config && \
	make -j$(nproc) && \
	make CONFIG_PREFIX=/opt/mydistro/initramfs install

# compile syslinux
RUN \
	cd /opt/mydistro/syslinux && \
	for f in debian/patches/*.patch; do patch -p1 < $f; done; unset f && \
	DATE=not-too-long make -j$(nproc) bios
RUN \
	cd /opt/mydistro/syslinux && \
	cp ./bios/core/isolinux.bin /opt/mydistro/myiso/isolinux && \
	cp ./bios/com32/elflink/ldlinux/ldlinux.c32 /opt/mydistro/myiso/isolinux && \
	cp ./bios/com32/lib/libcom32.c32 /opt/mydistro/myiso/isolinux && \
	cp ./bios/com32/libutil/libutil.c32 /opt/mydistro/myiso/isolinux && \
	cp ./bios/com32/menu/vesamenu.c32 /opt/mydistro/myiso/isolinux && \
	cp ./bios/com32/menu/menu.c32 /opt/mydistro/myiso/isolinux

# compile memtest86+
RUN \
	cd /opt/mydistro/memtest86plus/build64 && \
	make -j$(nproc) && \
	cp ./memtest.bin /opt/mydistro/myiso/memtest

# compile dropbear
RUN \
	cd /opt/mydistro/dropbear && \
	./configure --enable-static && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs

ADD init.sh /opt/mydistro/initramfs/init
ADD syslinux.cfg /opt/mydistro/myiso/isolinux/isolinux.cfg

RUN \
	cd /opt/mydistro/initramfs && \
	mkdir -p etc/init.d proc sys tmp && \
	cp ../busybox/examples/inittab ./etc/ && \
	touch ./etc/init.d/rcS && \
	chmod +x ./etc/init.d/rcS && \
	touch ./etc/fstab && \
	find . | cpio -H newc -o > /opt/mydistro/myiso/initramfs && \
	cd /opt/mydistro && \
	mkisofs -J -R -o mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table myiso

ADD build.sh /opt/mydistro

WORKDIR /opt/mydistro
