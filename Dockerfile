FROM debian:sid-slim

RUN \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -yq \
		autoconf automake autopoint bc bison build-essential bzip2 cpio curl \
		dosfstools extlinux file flex g++ gawk gcc genisoimage gettext \
		git groff libcrypt-dev libelf-dev libfreetype-dev libncurses-dev libpng-dev \
		libssl-dev libtool make nano nasm ncdu pkg-config python-is-python3 \
		python3 mtools texinfo tree unzip upx-ucl uuid-dev vim wget xz-utils && \
	rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
RUN chown root:root /docker-entrypoint.sh && chmod 544 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
