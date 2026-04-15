#!/bin/bash
set -exuo pipefail

# sudo apt install qemu-system-x86

ls -alh ./output

# qemu-system-x86_64: symbol lookup error: /snap/core20/current/lib/x86_64-linux-gnu/libpthread.so.0: undefined symbol: __libc_pthread_init, version GLIBC_PRIVATE
unset GTK_PATH

if [[ "${1:-}" == "--cli" ]]; then
	echo "To exit QEMU when running in a terminal without a graphical interface: Ctrl+A -> X"
	qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 2G -kernel ./output/bzImage -initrd ./output/initramfs.cpio.gz -append "console=ttyS0" -nographic
elif [[ "${1:-}" == "--qemu" ]]; then
	qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 2G -cdrom ./output/mydistro.iso -net nic,model=virtio -net user
elif [[ "${1:-}" == "--docker" ]]; then
	docker rmi -f mydistro-initramfs:latest || true
	docker import ./output/initramfs.tar.gz mydistro-initramfs:latest
	docker run --rm -it mydistro-initramfs:latest /bin/sh
else
	echo "Usage: $0 [--cli | --qemu | --docker]"
fi

# qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 2G ./output/boot.img
# qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 2G -drive format=raw,file=./output/boot.img
# qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 2G -drive format=raw,media=cdrom,readonly=on,file=./output/mydistro.iso
