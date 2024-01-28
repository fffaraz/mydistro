#!/bin/bash

qemu-system-x86_64 -M pc -enable-kvm -nographic -smp 1 -kernel ./output/images/bzImage -initrd ./output/images/rootfs.cpio -append "console=tty1 console=ttyS0" -net nic,model=virtio -net user
