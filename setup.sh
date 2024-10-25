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
  ln -s android/$d .
done

echo 'blissos' > etc/hostname

cat <<EOF > usr/sbin/autologin
#!/bin/sh
exec login -f root
EOF
chmod +x  usr/sbin/autologin
sed -i 's@1:2345:respawn:/sbin/getty@1:2345:respawn:/sbin/getty -n -l /usr/sbin/autologin@g' etc/inittab
sed -i -r 's|^(root:.*:)/bin/d?a?sh$|\1/bin/bash|g' etc/passwd

# shellcheck disable=SC2016
echo '[ -z "$DISPLAY" ] && { startx /usr/bin/jwm; poweroff; }' > root/.bash_profile
chmod +x  root/.bash_profile

for d in libselinux.so.1 libc.so.6 ld-linux-x86-64.so.2; do
  ln -s x86_64-linux-gnu/$d lib
done

find usr/{s,}bin -type c -exec rm -f {} +
rm -rf lib/{firmware,modules}

ln -s /system/lib/modules /vendor/firmware lib/

busybox --install -s /bin

/usr/sbin/update-rc.d dbus defaults
/usr/sbin/update-rc.d udev defaults
/usr/sbin/update-rc.d eudev defaults

find etc/rc*.d/ -type c | while read -r svc; do
  rsvc=$(echo "$svc" | sed -r 's|.*[SK][0-9]{2}||g')
  [ -f etc/init.d/"$rsvc" ] || continue
  rm "$svc"
  ln -s ../init.d/"$rsvc" "$svc"
done
