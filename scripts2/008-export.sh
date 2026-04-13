#!/bin/bash
set -exuo pipefail

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools

tar --exclude=/opt/mydistro -czf /opt/mydistro/output/stage3.tar.gz /
