FROM debian:sid-slim

WORKDIR /opt/mydistro

# 1. install dependencies
ADD scripts/0001-dependencies.sh /opt/mydistro/scripts/
RUN scripts/0001-dependencies.sh && rm -rf /var/lib/apt/lists/*

# 2. download source repositories
# ADD scripts/0002-source.sh /opt/mydistro/scripts/
# RUN scripts/0002-source.sh
ADD src /opt/mydistro/src/

# 3. compile kernel
# ADD assets/linux.config /opt/mydistro/src/linux/.config
ADD scripts/0003-kernel.sh /opt/mydistro/scripts/
RUN scripts/0003-kernel.sh

# 4. compile busybox
# ADD assets/busybox.config /opt/mydistro/src/busybox/.config
ADD scripts/0004-busybox.sh /opt/mydistro/scripts/
RUN scripts/0004-busybox.sh

# 5. compile syslinux
ADD scripts/0005-syslinux.sh /opt/mydistro/scripts/
RUN scripts/0005-syslinux.sh

# 6. compile memtest86+
ADD scripts/0006-memtest86.sh /opt/mydistro/scripts/
RUN scripts/0006-memtest86.sh

# 7. compile microwindows
ADD scripts/0007-microwindows.sh /opt/mydistro/scripts/
RUN scripts/0007-microwindows.sh

# 8. compile dropbear
ADD scripts/0008-dropbear.sh /opt/mydistro/scripts/
RUN scripts/0008-dropbear.sh

# 9. compile glibc
# ADD scripts/0009-glibc.sh /opt/mydistro/scripts/
# RUN scripts/0009-glibc.sh

# 10. compile curl
ADD scripts/0010-curl.sh /opt/mydistro/scripts/
RUN scripts/0010-curl.sh

# 11. compile nano
ADD scripts/0011-nano.sh /opt/mydistro/scripts/
RUN scripts/0011-nano.sh

# 12. initramfs
ADD assets/init.sh /opt/mydistro/initramfs-dir/init
ADD assets/syslinux.cfg /opt/mydistro/iso-dir/isolinux/isolinux.cfg
ADD scripts/0012-initramfs.sh /opt/mydistro/scripts/
RUN scripts/0012-initramfs.sh

ADD assets/mk-boot-img.sh /opt/mydistro
