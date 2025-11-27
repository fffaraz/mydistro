#!/bin/sh
set -x

export HOME=/root
export PS1='\w\$ '

/bin/mount -t proc proc /proc
/bin/mount -t sysfs sysfs /sys
# /bin/mount -t devtmpfs dev /dev

/bin/mount -t tmpfs -o mode=1777,strictatime tmpfs /tmp

# scan /sys and populate /dev
/sbin/mdev -s

/bin/hostname myhostname
/sbin/ifconfig lo 127.0.0.1

echo -e "\nBoot took $(cut -d' ' -f1 /proc/uptime) seconds\n"

sleep 1

exec /sbin/init
