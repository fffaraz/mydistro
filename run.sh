#!/bin/bash
set -exuo pipefail

# sudo apt install qemu-system-x86

ls -alh ./output

qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 2G -cdrom ./output/mydistro.iso -net nic,model=virtio -net user

# qemu-system-x86_64 ./output/boot.img
# qemu-system-x86_64 -drive format=raw,file=./output/boot.img 
# qemu-system-x86_64 -drive format=raw,media=cdrom,readonly=on,file=./output/mydistro.iso 

# qemu-system-x86_64 -m 512M -kernel ./output/bzImage -initrd ./output/initramfs.cpio -append "console=ttyS0" -nographic
# To exit QEMU when running in a terminal without a graphical interface: Ctrl+A -> X
