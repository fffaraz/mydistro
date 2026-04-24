#!/bin/bash
set -exuo pipefail

ln -sv /proc/self/mounts /etc/mtab

cp ./assets/etc/hosts /etc/hosts
cp ./assets/etc-passwd /etc/passwd
cp ./assets/etc-group /etc/group
