#!/bin/bash

# install dependencies

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq \
	autoconf bc bison build-essential bzip2 cpio curl \
	dosfstools extlinux flex g++ gcc genisoimage git libelf-dev \
	libfreetype-dev libncurses-dev libpng-dev libssl-dev libtool \
	make nano nasm pkg-config python-is-python3 python3 syslinux \
	unzip upx-ucl uuid-dev vim wget xz-utils ncdu tree gawk file texinfo
