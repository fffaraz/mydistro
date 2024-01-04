#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs -o mode=1777,strictatime tmpfs /tmp

# scan /sys and populate /dev
/sbin/mdev -s

hostname myhostname

export HOME=/root
export PS1='\w\$ '
export PATH=$PATH:/usr/local/sbin:/usr/local/bin

exec /sbin/init
