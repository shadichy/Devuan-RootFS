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

echo 'blisslabs' > /etc/hostname

cat <<EOF > /usr/sbin/autologin
#!/bin/sh
exec login -f root
EOF
chmod +x  usr/sbin/autologin
sed -i 's@1:2345:respawn:/sbin/getty@1:2345:respawn:/sbin/getty -n -l /usr/sbin/autologin@g' /etc/inittab
sed -i -r 's|^(root:.*:)/bin/d?a?sh$|\1/bin/bash|g' /etc/passwd

# shellcheck disable=SC2016
cat <<'EOF' >/root/.bash_profile
#!/bin/bash
# reload input devices
udevadm trigger
# reload font cache
fc-cache -fv
if [ -z "$DISPLAY" ] && ! pidof X; then
  startx /usr/bin/jwm
  poweroff
fi
EOF
chmod +x /root/.bash_profile

# Symlinks for chroot
for d in libselinux.so.1 libc.so.6 ld-linux-x86-64.so.2; do
  ln -s x86_64-linux-gnu/$d /lib/
done

rm -rf /lib/{firmware,modules}
ln -s /system/lib/modules /vendor/firmware /lib/

# Symlink fonts from Android
mkdir -p /usr/share/fonts
ln -s /system/fonts /usr/share/fonts/android

busybox --install -s /bin

# Enable dbus and udev services
update-rc.d dbus defaults
update-rc.d udev defaults
update-rc.d eudev defaults

# Remove /usr/sbin/policy-rc.d on Docker container
rm -rf \
  /etc/apt \
  /usr/include \
  /usr/lib/cmake \
  /usr/sbin/policy-rc.d \
  /usr/share/doc \
  /usr/share/doc-base \
  /usr/share/gtk-doc \
  /usr/share/info \
  /usr/share/man \
  /usr/share/man-db \
  /var/cache/* \
  /var/lib/apt \
  /var/lib/dpkg

find usr/lib/x86_64-linux-gnu -iname "*.cmake" -exec rm -f {} +

exit 0
