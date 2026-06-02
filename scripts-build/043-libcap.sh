#!/usr/bin/bash
set -exuo pipefail

cd ./src/libcap

# Don't ship the static archives.
sed -i '/install -m.*STA/d' libcap/Makefile

# Plain Makefile build (no autotools/meson). lib=lib keeps libs in /usr/lib;
# GOLANG=no / PAM_CAP=no skip the Go bindings and the PAM module.
make prefix=/usr lib=lib GOLANG=no PAM_CAP=no

# Install into the OS image, and into the live container so the systemd build
# that follows finds libcap's headers, libcap.so and libcap.pc.
make prefix=/usr lib=lib GOLANG=no PAM_CAP=no install DESTDIR="$INITRAMFS_DIR"
make prefix=/usr lib=lib GOLANG=no PAM_CAP=no install
