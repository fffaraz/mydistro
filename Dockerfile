FROM debian:sid-slim

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq nano build-essential bzip2 git vim make gcc libncurses-dev flex bison bc cpio libelf-dev libssl-dev syslinux dosfstools genisoimage wget curl && \
	exit 0

# curl -fsSL -o linux.zip https://codeload.github.com/torvalds/linux/zip/refs/heads/master && \
RUN \
	mkdir -p /opt/mydistro/initramfs && \
	mkdir -p /opt/mydistro/myiso/isolinux && \
	cd /opt/mydistro && \
	git clone --depth 1 https://github.com/torvalds/linux.git && \
	git clone --depth 1 https://git.busybox.net/busybox && \
	exit 0

RUN \
	cd /opt/mydistro && \
	curl -fsSL -o syslinux.tar.gz https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/Testing/6.04/syslinux-6.04-pre1.tar.gz && \
	tar xzf syslinux.tar.gz && \
	rm syslinux.tar.gz && \
	cp ./syslinux-6.04-pre1/bios/core/isolinux.bin /opt/mydistro/myiso/isolinux/ && \
	cp ./syslinux-6.04-pre1/bios/com32/elflink/ldlinux/ldlinux.c32 /opt/mydistro/myiso/isolinux/ && \
	exit 0

# make menuconfig
ADD linux.config /opt/mydistro/linux/.config
RUN cd /opt/mydistro/linux && make -j$(nproc) && cp ./arch/x86/boot/bzImage /opt/mydistro/myiso/

# make menuconfig
ADD busybox.config /opt/mydistro/busybox/.config
RUN cd /opt/mydistro/busybox && make -j$(nproc) && make CONFIG_PREFIX=/opt/mydistro/initramfs install

ADD init.sh /opt/mydistro/initramfs/init
ADD syslinux.cfg /opt/mydistro/myiso/isolinux/isolinux.cfg

RUN \
	cd /opt/mydistro/initramfs && \
	rm linuxrc && \
	find . | cpio -H newc -o > /opt/mydistro/myiso/initramfs && \
	cd /opt/mydistro && \
	mkisofs -J -R -o output.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table myiso && \
	exit 0

ADD build.sh /opt/mydistro
