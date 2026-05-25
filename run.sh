#!/bin/bash
set -exuo pipefail

# sudo apt install qemu-system-x86

# qemu-system-x86_64: symbol lookup error: /snap/core20/current/lib/x86_64-linux-gnu/libpthread.so.0: undefined symbol: __libc_pthread_init, version GLIBC_PRIVATE
unset GTK_PATH

OUTPUT_DIR="./output/2"

if [[ "${1:-}" == "--cli" ]]; then
	echo "To exit QEMU when running in a terminal without a graphical interface: Ctrl+A -> X"
	qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 4G -kernel $OUTPUT_DIR/bzImage -initrd $OUTPUT_DIR/initramfs.cpio.gz -append "console=ttyS0" -nographic

elif [[ "${1:-}" == "--iso" ]]; then
	qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 4G -cdrom $OUTPUT_DIR/mydistro.iso -net nic,model=virtio -net user
	# qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 4G -drive format=raw,media=cdrom,readonly=on,file=$OUTPUT_DIR/mydistro.iso

elif [[ "${1:-}" == "--img" ]]; then
	# qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 4G $OUTPUT_DIR/boot.img
	qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 4G -drive format=raw,file=$OUTPUT_DIR/boot.img

elif [[ "${1:-}" == "--docker" ]]; then
	docker rmi -f mydistro-initramfs:latest || true
	docker import $OUTPUT_DIR/initramfs.tar.gz mydistro-initramfs:latest
	docker run --rm -it mydistro-initramfs:latest /bin/sh

else
	echo "Usage: $0 [--cli | --iso | --img | --docker]"
fi
