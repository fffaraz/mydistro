FROM debian:sid-slim

ARG INSTALL_DEBUG_UTILS=1

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq \
		autoconf automake autopoint bc bison build-essential bzip2 cpio \
		dosfstools file flex g++ gawk gcc genisoimage gettext git gperf help2man \
		libblkid-dev libcrypt-dev libelf-dev libfreetype-dev libmpc-dev libmpfr-dev libncurses-dev \
		libpng-dev libssl-dev libtool libzstd-dev m4 make mtools nasm pkg-config python-is-python3 \
		python3 rsync texinfo uuid-dev xz-utils zlib1g-dev zstd && \
	if [ "$INSTALL_DEBUG_UTILS" = "1" ]; then \
		apt-get install -yq curl groff nano ncdu tree unzip upx-ucl vim wget; \
	fi && \
	rm -rf /var/lib/apt/lists/*
