#!/usr/bin/bash
set -exuo pipefail

mkdir -p $INITRAMFS_DIR/etc/ssl/certs
cp ./src/cacert.pem $INITRAMFS_DIR/etc/ssl/certs/ca-certificates.crt
