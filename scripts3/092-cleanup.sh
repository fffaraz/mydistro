#!/bin/bash
set -exuo pipefail

rm -rf /tmp/{*,.*}

find /usr/lib /usr/libexec -name \*.la -delete

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

# userdel -r tester || true

rm -f ./output/stage4.tar.gz
tar \
	--exclude=/opt/mydistro \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/dev \
	--exclude=/.dockerenv \
	-czf ./output/stage4.tar.gz /
