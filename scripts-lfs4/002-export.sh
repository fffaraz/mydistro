#!/usr/bin/bash
set -exuo pipefail

rm -f ./output/stage5.tar.gz
tar \
	--exclude=/.dockerenv \
	--exclude=/dev \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/opt/mydistro \
	-czf ./output/stage5.tar.gz /
