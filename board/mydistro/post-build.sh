#!/bin/sh
set -e

echo $(git describe) $(date +%Y-%m-%d-%H:%M:%S) > $TARGET_DIR/etc/build-id

BOARD_DIR=$(dirname "$0")

cp -f "$BOARD_DIR/grub.cfg" "$BINARIES_DIR/efi-part/EFI/BOOT/grub.cfg"
