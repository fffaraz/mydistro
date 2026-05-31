FROM debian:sid-slim

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq \
		autoconf automake autopoint bc bison bzip2 cpio \
		dosfstools file flex g++ gawk gcc genisoimage gettext git gperf help2man \
		libblkid-dev libcrypt-dev libelf-dev libmpc-dev libmpfr-dev \
		libssl-dev libtool libzstd-dev m4 make mtools nasm pkg-config python-is-python3 \
		python3 rsync texinfo uuid-dev xz-utils zlib1g-dev zstd && \
	rm -rf /var/lib/apt/lists/*
