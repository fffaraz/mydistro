#!/usr/bin/bash
set -exuo pipefail

cd ./src/meson

# meson is pure Python, but this distro builds CPython --without-ensurepip, so
# there is no pip/setuptools to install it the usual way. Drop the mesonbuild
# package into a fixed location and ship a small launcher that adds it to
# sys.path. This is Python-version independent, so it works both under the base
# image's python (pass 1) and our self-built CPython (pass 2).
install_meson() {
	local dest="$1"
	install -dm755 "${dest}/usr/lib/meson"
	cp -a mesonbuild "${dest}/usr/lib/meson/"
	install -dm755 "${dest}/usr/bin"
	printf '%s\n' \
		'#!/usr/bin/env python3' \
		'import sys' \
		"sys.path.insert(0, '/usr/lib/meson')" \
		'from mesonbuild import mesonmain' \
		'sys.exit(mesonmain.main())' \
		>"${dest}/usr/bin/meson"
	chmod 755 "${dest}/usr/bin/meson"
}

# Into the live container (so the systemd build that follows can run meson)...
install_meson ""
# ...and into the OS image (so pass 2 can rebuild systemd self-hosted).
install_meson "$INITRAMFS_DIR"
