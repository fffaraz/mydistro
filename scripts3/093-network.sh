#!/bin/bash
set -exuo pipefail

cp -v ./assets/etc/hostname /etc/hostname
cp -v ./assets/etc/hosts /etc/hosts
cp -v ./assets/etc/resolv.conf /etc/resolv.conf

systemctl disable systemd-networkd-wait-online || true

ln -sf /dev/null /etc/systemd/network/99-default.link

systemctl disable systemd-resolved || true
