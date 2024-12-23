#!/bin/bash

# Generate a grub-rescue iso so we can use it as the base for the iso
grub-mkrescue -o /grub-rescue.iso /iso
rm -rf /iso

# Generate initrd template
mkdir -p /initrd/usr/{bin,lib,lib64}
ln -st /initrd usr/{bin,lib,lib64}

# Copy binaries and libraries
find_dep() { ldd "$1" | awk '{print $3}' | xargs; }
for b in mount.ntfs-3g; do
  b=$(which $b)
  cp -t /initrd/bin $b
  cp -t /initrd/lib $(find_dep "$b")
done

# Busybox is explicitly handled
cp -t /initrd/bin /usr/share/bliss/busybox
cp -t /initrd/lib $(find_dep /initrd/bin/busybox)

# Linker
cp -t /initrd/bin /bin/ld.so
cp -t /initrd/lib /usr/lib/*/ld-linux-x86-64.so.*
cp -t /initrd/lib64 /usr/lib64/ld-linux-x86-64.so.*

# Wrap initrd up
tar -czvf /initrd_lib.tar.gz /initrd

exit 0
