#!/bin/sh

mkdir /proc
mkdir /sys

mount -t proc none /proc
mount -t sysfs none /sys

# scan /sys and populate /dev
/sbin/mdev -s

hostname myhostname

export HOME=/root

exec /bin/sh
