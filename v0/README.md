
```
docker pull debian:sid-slim
docker build -t mydistro .

docker run --privileged --rm -it -v $(pwd)/output:/output mydistro
cp mydistro.iso /output

qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 256M -cdrom ./output/mydistro.iso -net nic,model=virtio -net user
```

```
qemu-system-x86_64 ./output/boot.img
qemu-system-x86_64 -m 512M -kernel bzImage -initrd initramfs.cpio -append "console=ttyS0" -nographic
```
