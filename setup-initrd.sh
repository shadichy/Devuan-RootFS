#!/bin/bash

mkdir /docker_busybox
wget "https://github.com/docker-library/busybox/raw/refs/heads/dist-amd64/latest/glibc/amd64/rootfs.tar.gz" -O - | tar -C /docker_busybox -xzf -

mv /docker_busybox/bin/busybox /iso/out/bin/busybox
chmod +x /iso/out/bin/busybox

cp -t /iso/out/lib/ \
  /lib/*/libc.so.* \
  /lib/*/libdl.so.* \
  /lib/*/libm.so.* \
  /lib/*/libpthread.so.* \
  /lib/*/libresolv.so.* \
  /lib/*/librt.so.* \
  /lib/*/ld-linux-x86-64.so.*

cp /lib64/ld-linux-x86-64.so.* /iso/out/lib64/
cp /bin/ld.so /iso/out/bin/

# NTFS3 support (will be deprecated)
cp /sbin/mount.ntfs-3g /iso/out/bin/
cp /lib/*/libntfs-3g.so.* /iso/out/lib/

cd /iso/out
find . | sed 's|^\.\/||g' | tail -n +2 | cpio -o -H newc > /iso/initrd.img
cd /

rm -rf /docker_busybox /iso/out
