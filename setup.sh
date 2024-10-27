#!/bin/bash

for d in \
  android \
  boot/grub \
  boot/efi \
  cdrom \
  root; do
  mkdir -p $d
done

for d in \
  system \
  vendor; do
  ln -s android/$d /
done

echo 'blissos.org' > /etc/hostname


for d in libselinux.so.1 libc.so.6 ld-linux-x86-64.so.2; do
  ln -s x86_64-linux-gnu/$d /lib/
done

rm -rf /lib/{firmware,modules}
ln -s /system/lib/modules /vendor/firmware /lib/
ln -s /system/fonts /usr/share/fonts/android

busybox --install -s /bin

update-rc.d dbus defaults
update-rc.d udev defaults
update-rc.d eudev defaults

rm -rf /usr/include/*
rm -rf /usr/lib/x86_64-linux-gnu/cmake

exit 0
