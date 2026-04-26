#!/bin/bash
set -exuo pipefail

cat > /etc/locale.conf << "EOF"
LANG=en_US.UTF-8
EOF

cp -v ../../assets/etc/profile /etc/profile
