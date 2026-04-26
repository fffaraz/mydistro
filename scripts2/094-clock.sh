#!/bin/bash
set -exuo pipefail

cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF
