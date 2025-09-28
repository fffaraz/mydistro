#!/bin/bash

# install dependencies

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq \
	autoconf automake autopoint bc bison build-essential bzip2 cpio curl \
	dosfstools extlinux file flex g++ gawk gcc genisoimage gettext \
	git groff libelf-dev libfreetype-dev libncurses-dev libpng-dev \
	libssl-dev libtool make nano nasm ncdu pkg-config python-is-python3 \
	python3 syslinux texinfo tree unzip upx-ucl uuid-dev vim wget xz-utils
