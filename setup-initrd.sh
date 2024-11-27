#!/bin/bash

mkdir /docker_busybox
wget "https://github.com/docker-library/busybox/raw/refs/heads/dist-amd64/latest/glibc/amd64/rootfs.tar.gz" -O - | tar -C /docker_busybox -xzf -
mv /docker_busybox/bin/busybox /iso/out/bin/busybox
chmod +x /iso/out/bin/busybox
rm -rf /docker_busybox

cp -t /iso/out/lib/ \
  /usr/lib/*/libc.so.* \
  /usr/lib/*/libdl.so.* \
  /usr/lib/*/libm.so.* \
  /usr/lib/*/libpthread.so.* \
  /usr/lib/*/libresolv.so.* \
  /usr/lib/*/librt.so.* \
  /usr/lib/*/ld-linux-x86-64.so.*

cp /usr/bin/ld.so /iso/out/bin/

# NTFS3 support (will be deprecated)
cp /usr/sbin/mount.ntfs-3g /iso/out/bin/
cp /usr/lib/*/libntfs-3g.so.* /iso/out/lib/

cd /iso/out
find . | sed 's|^\.\/||g' | tail -n +2 | cpio -o -H newc | tee /iso/initrd.img
cd /

rm -rf /iso/out
