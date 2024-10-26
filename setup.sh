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

cat <<EOF > /usr/sbin/autologin
#!/bin/sh
exec login -f root
EOF
chmod +x  usr/sbin/autologin
sed -i 's@1:2345:respawn:/sbin/getty@1:2345:respawn:/sbin/getty -n -l /usr/sbin/autologin@g' /etc/inittab
sed -i -r 's|^(root:.*:)/bin/d?a?sh$|\1/bin/bash|g' /etc/passwd

# shellcheck disable=SC2016
echo 'udevadm trigger && [ -z "$DISPLAY" ] && { startx /usr/bin/jwm; poweroff; }' > /root/.bash_profile
chmod +x  /root/.bash_profile

for d in libselinux.so.1 libc.so.6 ld-linux-x86-64.so.2; do
  ln -s x86_64-linux-gnu/$d /lib/
done

rm -rf /lib/{firmware,modules}
ln -s /system/lib/modules /vendor/firmware /lib/

busybox --install -s /bin

update-rc.d dbus defaults
update-rc.d udev defaults
update-rc.d eudev defaults

rm -rf /usr/include/*
rm -rf /usr/lib/x86_64-linux-gnu/cmake
