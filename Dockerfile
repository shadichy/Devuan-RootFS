FROM devuan/devuan:excalibur

COPY . /

RUN apt update && apt upgrade -y

# Let's start with the CLI tool I would like to have :)
RUN apt install htop fastfetch nano -y

# Some essential tools
RUN apt install util-linux busybox e2fsprogs efibootmgr -y

# X11
RUN apt install xserver-xorg-video-all xserver-xorg-core xserver-xorg-input-all xinit -y

# Xfce
# Beside what is needed for the DE, we also install extra programs for the minimal experience
# This include a file manager (thunar), a text editor (mousepad) and a terminal (xfce4-terminal)
# We also include xfce4-battery-plugin for laptop users to see their battery
RUN apt install xfdesktop4 xfwm4 xfce4-panel xfce4-settings xfce4-power-manager xfce4-session xfconf xfce4-notifyd -y
RUN apt install thunar mousepad xfce4-terminal xfce4-battery-plugin -y

# Grub2
# Include for both Legacy BIOS & UEFI (IA32/amd64)
RUN apt install grub-common grub2-common grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin -y

# Gparted
RUN apt install gparted -y

# Calamares
RUN apt install calamares calamares-extensions calamares-extensions-data -y

# ntfs-3g so we can pull this out for initrd
RUN apt install ntfs-3g -y

# Remove .dockerenv once we've done everything
RUN rm -f /.dockerenv
