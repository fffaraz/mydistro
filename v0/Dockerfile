FROM debian:sid-slim

# install dependencies
RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq autoconf bc bison build-essential bzip2 cpio curl \
	dosfstools extlinux flex g++ gcc genisoimage git libelf-dev \
	libfreetype-dev libncurses-dev libpng-dev libssl-dev libtool \
	make nano nasm pkg-config python-is-python3 python3 syslinux \
	unzip upx-ucl uuid-dev vim wget xz-utils

# download source code
RUN \
	mkdir -p /opt/mydistro/initramfs && \
	mkdir -p /opt/mydistro/myiso/isolinux && \
	cd /opt/mydistro && \
	git clone --depth 1 -b v6.16 https://github.com/torvalds/linux.git && \
	git clone --depth 1 https://git.busybox.net/busybox && \
	git clone --depth 1 https://salsa.debian.org/images-team/syslinux.git && \
	git clone --depth 1 https://github.com/memtest86plus/memtest86plus.git && \
	git clone --depth 1 https://github.com/ghaerr/microwindows.git && \
	git clone --depth 1 https://github.com/mkj/dropbear.git && \
	git clone --depth 1 https://github.com/curl/curl.git

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
	sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config && \
	sed -i 's/CONFIG_TC=y/CONFIG_TC=n/' .config && \
	make -j$(nproc) && \
	make CONFIG_PREFIX=/opt/mydistro/initramfs install

# compile syslinux
RUN \
	cd /opt/mydistro/syslinux && \
	for f in debian/patches/*.patch; do patch -p1 < $f; done; unset f && \
	sed -i '/#include <stdbool.h>/a #include <stdio.h>' ./com32/lib/syslinux/debug.c && \
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
	cd /opt/mydistro/memtest86plus/build/x86_64 && \
	make -j$(nproc) && \
	cp ./memtest_shared.bin /opt/mydistro/myiso/memtest

# compile microwindows
RUN \
	cd /opt/mydistro/microwindows/src && \
	cp Configs/config.linux-fb config && \
	sed -i 's/NX11                     = N/NX11 = Y/' config && \
	sed -i 's/^X11_INCLUDE=\$(X11HDRLOCATION)/#&/; s/^#X11_INCLUDE=.\/X11-local/X11_INCLUDE=.\/X11-local/' nx11/Makefile && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs

# compile dropbear
RUN \
	cd /opt/mydistro/dropbear && \
	./configure --enable-static && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs

# compile curl
RUN \
	cd /opt/mydistro/curl && \ 
	autoreconf -vif && \
	./configure --disable-shared --enable-static --without-libpsl --without-ssl --without-zstd --without-zlib && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs

ADD init.sh /opt/mydistro/initramfs/init
ADD syslinux.cfg /opt/mydistro/myiso/isolinux/isolinux.cfg

RUN \
	cd /opt/mydistro/initramfs && \
	mkdir -p etc/init.d proc sys tmp home mnt usr/lib var && \
	cp ../busybox/examples/inittab ./etc/ && \
	touch ./etc/init.d/rcS && \
	chmod +x ./etc/init.d/rcS && \
	touch ./etc/fstab && \
	echo "root::0:0:root:/root:/bin/sh" > ./etc/passwd && \
	echo "root:x:0:" > ./etc/group && \
	echo "nameserver 8.8.8.8" > ./etc/resolv.conf && \
	find . | cpio -H newc -o > /opt/mydistro/myiso/initramfs && \
	cd /opt/mydistro && \
	mkisofs -J -R -o mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table myiso

ADD mk-boot-img.sh /opt/mydistro

WORKDIR /opt/mydistro
