#!/bin/bash
set -exuo pipefail

./scripts/001-files.sh
./scripts/002-grub.sh
./scripts/003-export.sh
