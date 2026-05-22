#!/bin/bash
set -exuo pipefail

rm -f ./output/stage5.tar.gz
tar \
	--exclude=/opt/mydistro \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/dev \
	--exclude=/.dockerenv \
	-czf ./output/stage5.tar.gz /
