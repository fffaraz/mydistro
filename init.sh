#!/bin/sh

mkdir /proc
mkdir /sys
mkdir /tmp

mount -t proc none /proc
mount -t sysfs none /sys
mount -t tmpfs -o mode=1777,strictatime tmpfs /tmp

# scan /sys and populate /dev
/sbin/mdev -s

hostname myhostname

export HOME=/root
export PS1='\w\$ '

exec /bin/sh
