FROM devuan/devuan:excalibur

COPY . /

RUN apt update && apt upgrade -y

# Let's start with the CLI tool I would like to have :)
RUN apt install htop fastfetch nano -y

# Some essential tools
RUN apt install util-linux busybox e2fsprogs efibootmgr -y

# X11
RUN apt install xserver-xorg-video-all xserver-xorg-core xserver-xorg-input-all xinit -y

# Supposedly we want to install a DE, but Xfce seems to tax us a lot of resources
# So we decided to use JWM, with some extra tools
# a file manager (doublecmd-qt), a terminal (xterm) and a text editor (mousepad)
RUN apt install jwm doublecmd-qt xterm mousepad -y

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
