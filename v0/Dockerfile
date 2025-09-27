FROM debian:sid-slim

# install dependencies
RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq autoconf bc bison build-essential bzip2 cpio curl \
	dosfstools extlinux flex g++ gcc genisoimage git libelf-dev \
	libfreetype-dev libncurses-dev libpng-dev libssl-dev libtool \
	make nano nasm pkg-config python-is-python3 python3 syslinux \
	unzip upx-ucl uuid-dev vim wget xz-utils ncdu tree gawk file texinfo && \
	rm -rf /var/lib/apt/lists/*

# download source repositories
RUN \
	mkdir -p /opt/mydistro/initramfs-dir && \
	mkdir -p /opt/mydistro/iso-dir && \
	mkdir -p /opt/mydistro/src && \
	cd /opt/mydistro/src && \
	git config --global advice.detachedHead false && \
	git clone --depth 1 -b v6.16 https://github.com/torvalds/linux.git && \
	git clone --depth 1 https://git.busybox.net/busybox && \
	git clone --depth 1 https://salsa.debian.org/images-team/syslinux.git && \
	git clone --depth 1 https://github.com/memtest86plus/memtest86plus.git && \
	git clone --depth 1 https://github.com/ghaerr/microwindows.git && \
	git clone --depth 1 https://github.com/mkj/dropbear.git && \
	git clone --depth 1 -b glibc-2.42 git://sourceware.org/git/glibc.git && \
	git clone --depth 1 https://github.com/curl/curl.git && \
	exit 0

# compile kernel
# ADD src/linux.config /opt/mydistro/src/linux/.config
RUN \
	cd /opt/mydistro/src/linux && \
	make defconfig && \
	sed -i 's/^CONFIG_CC_VERSION_TEXT=.*/CONFIG_CC_VERSION_TEXT="gcc (mydistro)"/' .config && \
	make -j$(nproc) && \
	cp ./arch/x86/boot/bzImage /opt/mydistro/iso-dir/bzImage

# compile busybox
# ADD src/busybox.config /opt/mydistro/src/busybox/.config
RUN \
	cd /opt/mydistro/src/busybox && \
	make defconfig && \
	sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config && \
	sed -i 's/CONFIG_TC=y/CONFIG_TC=n/' .config && \
	make -j$(nproc) && \
	make CONFIG_PREFIX=/opt/mydistro/initramfs-dir install

# compile syslinux
# git://repo.or.cz/syslinux.git
RUN \
	cd /opt/mydistro/src/syslinux && \
	for f in debian/patches/*.patch; do patch -p1 < $f; done; unset f && \
	sed -i '/#include <stdbool.h>/a #include <stdio.h>' ./com32/lib/syslinux/debug.c && \
	DATE=not-too-long make -j$(nproc) bios
RUN \
	cd /opt/mydistro/src/syslinux && \
	mkdir -p /opt/mydistro/iso-dir/isolinux && \
	cp ./bios/core/isolinux.bin /opt/mydistro/iso-dir/isolinux && \
	cp ./bios/com32/elflink/ldlinux/ldlinux.c32 /opt/mydistro/iso-dir/isolinux && \
	cp ./bios/com32/lib/libcom32.c32 /opt/mydistro/iso-dir/isolinux && \
	cp ./bios/com32/libutil/libutil.c32 /opt/mydistro/iso-dir/isolinux && \
	cp ./bios/com32/menu/vesamenu.c32 /opt/mydistro/iso-dir/isolinux && \
	cp ./bios/com32/menu/menu.c32 /opt/mydistro/iso-dir/isolinux

# compile memtest86+
RUN \
	cd /opt/mydistro/src/memtest86plus/build/x86_64 && \
	make -j$(nproc) && \
	cp ./mt86plus /opt/mydistro/iso-dir/memtest

# compile microwindows
RUN \
	cd /opt/mydistro/src/microwindows/src && \
	cp Configs/config.linux-fb config && \
	sed -i 's/NX11                     = N/NX11 = Y/' config && \
	sed -i 's/^X11_INCLUDE=\$(X11HDRLOCATION)/#&/; s/^#X11_INCLUDE=.\/X11-local/X11_INCLUDE=.\/X11-local/' nx11/Makefile && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs-dir

# compile dropbear
RUN \
	cd /opt/mydistro/src/dropbear && \
	./configure --enable-static && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs-dir

# compile musl
# git://git.musl-libc.org/musl

# compile glibc
RUN \
	cd /opt/mydistro/src/glibc && \
	mkdir build && \
	cd build && \
	../configure --prefix /opt/mydistro/initramfs-dir/usr/local/glibc && \
	make -j$(nproc) && \
	exit 0
#	make install

# compile curl
RUN \
	cd /opt/mydistro/src/curl && \ 
	autoreconf -vif && \
	./configure CFLAGS='-static' LDFLAGS='-static -static-libgcc' --disable-shared --enable-static --without-brotli --without-libpsl --without-ssl --without-zstd --without-zlib && \
	make -j$(nproc) && \
	make install DESTDIR=/opt/mydistro/initramfs-dir

ADD src/init.sh /opt/mydistro/initramfs-dir/init
ADD src/syslinux.cfg /opt/mydistro/iso-dir/isolinux/isolinux.cfg

# dd if=/dev/zero of=./largefile count=102400 bs=4096 && \
RUN \
	cd /opt/mydistro/initramfs-dir && \
	mkdir -p etc/init.d proc sys tmp home mnt usr/lib var && \
	cp ../src/busybox/examples/inittab ./etc/ && \
	touch ./etc/init.d/rcS && \
	chmod +x ./etc/init.d/rcS && \
	touch ./etc/fstab && \
	echo "root::0:0:root:/root:/bin/sh" > ./etc/passwd && \
	echo "root:x:0:" > ./etc/group && \
	echo "nameserver 8.8.8.8" > ./etc/resolv.conf && \
	find . | cpio -H newc -o > /opt/mydistro/iso-dir/initramfs && \
	cd /opt/mydistro && \
	mkisofs -J -R -o mydistro.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table iso-dir

ADD src/mk-boot-img.sh /opt/mydistro

WORKDIR /opt/mydistro
