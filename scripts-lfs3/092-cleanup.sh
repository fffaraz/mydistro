#!/usr/bin/bash
set -exuo pipefail

rm -rf /tmp/{*,.*}

find /usr/lib /usr/libexec -name \*.la -delete

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

# userdel -r tester || true

rm -f ./output/stage4.tar.gz
tar \
	--exclude=/.dockerenv \
	--exclude=/dev \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/opt/mydistro \
	-czf ./output/stage4.tar.gz /
