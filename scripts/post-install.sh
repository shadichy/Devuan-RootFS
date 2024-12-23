#!/bin/bash

# Generate a grub-rescue iso so we can use it as the base for the iso
grub-mkrescue -o /grub-rescue.iso /iso
rm -rf /iso

# Generate initrd template
mkdir -p /initrd/usr/{bin,lib,lib64}
ln -st /initrd usr/{bin,lib,lib64}
for b in mount.ntfs-3g ld.so busybox; do
  b=$(which $b)
  cp -t /initrd/bin $b
  cp -t /initrd/lib $(ldd "$b" | awk '{print $3}' | xargs)
done
cp -t /initrd/lib install/usr/lib/*/ld-linux-x86-64.so.*
cp -t /initrd/lib64 install/usr/lib64/ld-linux-x86-64.so.*

# Wrap initrd up
tar -czvf /initrd_lib.tar.gz /initrd

exit 0
