#!/usr/bin/bash
set -exuo pipefail

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

rm -f ./output/stage3.tar.gz
tar \
	--exclude=/.dockerenv \
	--exclude=/dev \
	--exclude=/proc \
	--exclude=/sys \
	--exclude=/opt/mydistro \
	-czf ./output/stage3.tar.gz /
