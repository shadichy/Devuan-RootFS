FROM devuan/migrated:excalibur-slim

COPY . /

RUN apt update && apt upgrade -y

# Let's start with the CLI tool I would like to have :)
RUN apt install htop fastfetch nano -y

# Some essential tools
RUN apt install util-linux busybox e2fsprogs exfatprogs dosfstools f2fs-tools btrfs-progs efibootmgr -y

# X11
RUN apt install xserver-xorg-video-all xserver-xorg-core xserver-xorg-input-all xserver-xorg-video-intel xserver-xorg-input-wacom xinit -y

# Supposedly we want to install a DE, but Xfce seems to tax us a lot of resources
# So we decided to use JWM, with some extra tools
# a file manager (doublecmd-qt), a terminal (xterm) and a text editor (l3afpad)
RUN apt install jwm doublecmd-qt xterm l3afpad -y

# Grub2
# Include for both Legacy BIOS & UEFI (IA32/amd64)
RUN apt install grub-common grub2-common grub-pc-bin grub-efi-ia32-bin grub-efi-amd64-bin -y

# As an extra, install gxmessage and consolekit for shutdown
RUN apt install gxmessage consolekit -y

# Gparted
RUN apt install gparted -y

# Calamares
RUN apt install calamares calamares-extensions calamares-extensions-data -y

# ntfs-3g so we can pull this out for initrd
RUN apt install ntfs-3g -y

# Install programs to generate grub-rescue.iso
RUN apt install xorriso mtools -y

# Generate a grub-rescue iso so we can use it as the base for the iso
RUN grub-mkrescue -o /grub-rescue.iso

# Remove xorriso once done
RUN apt remove xorriso mtools -y

# Try to strip down the image further
RUN dpkg --remove --force-depends libasound2-data fonts-dejavu-core fonts-dejavu-mono
RUN rm -rf /usr/include/*
