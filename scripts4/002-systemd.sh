#!/bin/bash
set -exuo pipefail

systemctl disable systemd-networkd-wait-online || true

ln -sf /dev/null /etc/systemd/network/99-default.link

systemctl disable systemd-resolved || true

mkdir -pv /etc/systemd/system/getty@tty1.service.d

cat >/etc/systemd/system/getty@tty1.service.d/noclear.conf <<"EOF"
[Service]
TTYVTDisallocate=no
EOF

mkdir -p /etc/tmpfiles.d
cp /usr/lib/tmpfiles.d/tmp.conf /etc/tmpfiles.d
