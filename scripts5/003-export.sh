#!/bin/bash
set -exuo pipefail

rm -f ./output/stage6.tar.gz
tar \
	--exclude=/opt/mydistro \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/dev \
	--exclude=/.dockerenv \
	-czf ./output/stage6.tar.gz /
