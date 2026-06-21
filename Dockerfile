FROM debian:sid-slim

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq \
		autoconf automake autopoint bc bison file flex g++ gawk gcc \
		gettext gperf help2man libblkid-dev libelf-dev libtool m4 make \
		patch pkg-config python3 texinfo uuid-dev xz-utils zlib1g-dev && \
	rm -rf /var/lib/apt/lists/*
