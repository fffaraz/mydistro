#!/bin/bash
set -exuo pipefail

cp -v ./assets/etc/hostname /etc/hostname
cp -v ./assets/etc/hosts /etc/hosts
cp -v ./assets/etc/resolv.conf /etc/resolv.conf
cp -v ./assets/etc/adjtime /etc/adjtime
cp -v ./assets/etc/vconsole.conf /etc/vconsole.conf
cp -v ./assets/etc/inputrc /etc/inputrc
cp -v ./assets/etc/shells /etc/shells
cp -v ./assets/etc/profile /etc/profile
cp -v ./assets/etc/lfs-release /etc/lfs-release
cp -v ./assets/etc/lsb-release /etc/lsb-release
cp -v ./assets/etc/os-release /etc/os-release
cp -v ./assets/etc/fstab /etc/fstab

install -v -m755 -d /etc/modprobe.d
cp -v ./assets/etc/modprobe.d/usb.conf /etc/modprobe.d/usb.conf

mkdir -pv /boot/grub
cp -v ./assets/boot/grub/grub.cfg /boot/grub/grub.cfg

mkdir -pv /etc/systemd/system/getty@tty1.service.d
cp -v ./assets/etc/systemd/system/getty@tty1.service.d/noclear.conf /etc/systemd/system/getty@tty1.service.d/noclear.conf
