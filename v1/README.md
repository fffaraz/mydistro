
```
docker pull debian:sid-slim
docker build -t mydistro .

docker run --privileged --rm -it -v $(pwd)/output:/output mydistro
cp *.iso /output

qemu-system-x86_64 -cpu host -enable-kvm -smp 2 -m 8G -cdrom ./output/mydistro.iso -net nic,model=virtio -net user
```
