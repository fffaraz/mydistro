#!/usr/bin/bash
set -exuo pipefail

cd ./src/ninja

# No prebuilt ninja in the base image — bootstrap it with python + the C++
# toolchain. Produces a ./ninja binary.
python3 configure.py --bootstrap

# Install into the OS image (for pass-2 self-hosting) and the live container
# (so the systemd build that follows can use it).
install -vDm755 ninja "$INITRAMFS_DIR/usr/bin/ninja"
install -vDm755 ninja /usr/bin/ninja
