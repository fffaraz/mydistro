#!/usr/bin/bash
set -exuo pipefail

cd ./src/dbus

# dbus links expat (a hard dependency) and libsystemd (for its systemd
# integration — see below). Both were installed only into the OS image
# (DESTDIR=$INITRAMFS_DIR), not the pass-1 debian build container, so point
# pkg-config at the staging tree. PKG_CONFIG_SYSROOT_DIR rewrites each .pc
# file's -I/-L into $INITRAMFS_DIR, so this resolves correctly no matter where
# the libs landed (systemd's meson may use a multiarch libdir; expat uses
# /usr/lib). In pass 2 the same dirs exist in that pass's staging tree.
export PKG_CONFIG_SYSROOT_DIR="$INITRAMFS_DIR"
export PKG_CONFIG_PATH="$(find "$INITRAMFS_DIR/usr/lib" "$INITRAMFS_DIR/usr/lib64" "$INITRAMFS_DIR/usr/share" -maxdepth 2 -name pkgconfig -type d 2>/dev/null | paste -sd:)"

rm -rf build
mkdir -p build
cd build

# systemd=enabled is what makes dbus install dbus.service / dbus.socket AND the
# multi-user.target.wants / sockets.target.wants enablement symlinks into our
# unit dir, so PID 1 socket-activates the system bus. Without it, systemctl and
# logind would have no bus to talk to. The unit dirs are set explicitly rather
# than probed from systemd.pc (which the sysroot rewrite would not apply to).
meson setup .. \
	--prefix=/usr \
	--buildtype=release \
	-D message_bus=true \
	-D tools=true \
	-D systemd=enabled \
	-D systemd_system_unitdir=/usr/lib/systemd/system \
	-D systemd_user_unitdir=/usr/lib/systemd/user \
	-D dbus_user=messagebus \
	-D apparmor=disabled \
	-D selinux=disabled \
	-D libaudit=disabled \
	-D x11_autolaunch=disabled \
	-D modular_tests=disabled \
	-D doxygen_docs=disabled \
	-D ducktype_docs=disabled \
	-D xml_docs=disabled \
	-D qt_help=disabled

ninja

DESTDIR=$INITRAMFS_DIR ninja install

# meson_post_install.py only sets the launch helper setuid when the messagebus
# user exists in the *build* container (it doesn't, so it prints a skip notice).
# Set it on the image directly. gid 18 == messagebus in assets/etc/{passwd,group}.
chown 0:18 "$INITRAMFS_DIR/usr/libexec/dbus-daemon-launch-helper"
chmod 4750 "$INITRAMFS_DIR/usr/libexec/dbus-daemon-launch-helper"
