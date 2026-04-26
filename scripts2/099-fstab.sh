#!/bin/bash
set -exuo pipefail

# Site-specific: edit device names and filesystem types before booting.
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

#/dev/<xxx>     /            <fff>    defaults            1     1
#/dev/<yyy>     swap         swap     pri=1               0     0

# End /etc/fstab
EOF
