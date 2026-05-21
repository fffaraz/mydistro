#!/bin/bash
set -exuo pipefail

cp -r --reflink=auto ./src-ro ./src

export HOME=/root
export TERM=xterm-256color
export PS1='\u@\h \W]\$ '
export PATH=/usr/bin:/usr/sbin:/bin:/sbin
export MAKEFLAGS=-j$(nproc)
export TESTSUITEFLAGS=-j$(nproc)

COMMON_FLAGS="-O3 -pipe -march=native -Wno-error"
export CFLAGS="${COMMON_FLAGS}"
export CXXFLAGS="${COMMON_FLAGS}"

./scripts/093-network.sh
./scripts/094-clock.sh
./scripts/095-locale.sh
./scripts/096-inputrc.sh
./scripts/097-etcshells.sh
./scripts/098-systemd-custom.sh

./scripts/099-fstab.sh
./scripts/100-kernel.sh
./scripts/101-grub.sh
