docker build -t mydistro .
docker run --privileged --rm -it -v $(pwd)/mydistro:/mydistro mydistro

qemu-system-x86_64 -cdrom ./mydistro/output.iso
qemu-system-x86_64 boot.img
qemu-system-x86_64 -m 512M -kernel bzImage -initrd initramfs.cpio -append "console=ttyS0" -nographic

https://repo.or.cz/syslinux.git
https://wiki.syslinux.org/wiki/index.php?title=Development
https://pub.nethence.com/booting/syslinux-install
https://wiki.archlinux.org/title/syslinux
https://wiki.gentoo.org/wiki/Syslinux
