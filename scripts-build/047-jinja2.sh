#!/usr/bin/bash
set -exuo pipefail

cd ./src/jinja2

# jinja2 (pure Python) is required by systemd's meson to render templates
# (meson.build: python3 modules: ['jinja2']). No pip in this distro, so copy
# the package into the shared vendor dir that 000-build.sh puts on PYTHONPATH.
# Its only dependency, markupsafe, is installed by the previous step.
install_pkg() {
	local dest="$1"
	install -dm755 "${dest}/usr/lib/python3-vendor"
	rm -rf "${dest}/usr/lib/python3-vendor/jinja2"
	cp -a src/jinja2 "${dest}/usr/lib/python3-vendor/"
}

install_pkg ""
install_pkg "$INITRAMFS_DIR"
