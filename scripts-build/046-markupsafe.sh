#!/usr/bin/bash
set -exuo pipefail

cd ./src/markupsafe

# MarkupSafe is jinja2's only dependency. It ships an optional C speedup but
# falls back to a pure-Python implementation (_native.py) when that isn't
# compiled, so no build step is needed. systemd's meson runs the system
# python3 directly, so the package must be importable from PYTHONPATH (set in
# 000-build.sh) — drop it into the shared vendor dir.
install_pkg() {
	local dest="$1"
	install -dm755 "${dest}/usr/lib/python3-vendor"
	rm -rf "${dest}/usr/lib/python3-vendor/markupsafe"
	cp -a src/markupsafe "${dest}/usr/lib/python3-vendor/"
}

# Live container (for the systemd build that follows) and the OS image (so
# pass 2 can rebuild systemd self-hosted).
install_pkg ""
install_pkg "$INITRAMFS_DIR"
