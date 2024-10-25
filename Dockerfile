FROM devuan/migrated:excalibur-slim

COPY . /

RUN apt update && apt upgrade -y

# Let's start with the CLI tool I would like to have :)
RUN apt install htop fastfetch nano -y

# Core SysVinit
RUN apt install sysvinit-core orphan-sysvinit-scripts procps acpid -y

# Some essential tools
RUN apt install util-linux bash busybox e2fsprogs exfatprogs dosfstools f2fs-tools btrfs-progs efibootmgr -y

# X11
RUN apt install xserver-xorg-video-all xserver-xorg-core xserver-xorg-input-all xserver-xorg-video-intel xinit -y

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
RUN dpkg --remove --force-depends --force-remove-essential libasound2-data extra-cmake-modules libx11proto-dev debconf debianutils kinit-dev kirigami2-dev libegl-dev libgl-dev libglu1-mesa-dev libglx-dev libkf5archive-dev libkf5auth-dev libkf5auth-dev-bin libkf5bookmarks-dev libkf5codecs-dev libkf5completion-dev libkf5config-dev libkf5config-dev-bin libkf5configwidgets-dev libkf5coreaddons-dev libkf5coreaddons-dev-bin libkf5crash-dev libkf5dbusaddons-dev libkf5declarative-dev libkf5doctools-dev libkf5emoticons-dev libkf5globalaccel-dev libkf5guiaddons-dev libkf5i18n-dev libkf5iconthemes-dev libkf5itemmodels-dev libkf5itemviews-dev libkf5jobwidgets-dev libkf5kdelibs4support-dev libkf5kio-dev libkf5notifications-dev libkf5package-dev libkf5parts-dev libkf5service-dev libkf5solid-dev libkf5sonnet-dev libkf5sonnet-dev-bin libkf5textwidgets-dev libkf5unitconversion-dev libkf5widgetsaddons-dev libkf5windowsystem-dev libkf5xmlgui-dev libopengl-dev libqt5svg5-dev libqt5x11extras5-dev libssl-dev libvulkan-dev libx11-dev libxau-dev libxcb1-dev libxdmcp-dev libxext-dev libyaml-cpp-dev qt5-qmake qt5-qmake-bin qtbase5-dev qtbase5-dev-tools qtdeclarative5-dev qtdeclarative5-dev-tools qtscript5-dev qttools5-dev qttools5-dev-tools xtrans-dev
RUN rm -rf /usr/include/*
RUN rm -rf /usr/lib/x86_64-linux-gnu/cmake

RUN mv /tmp/setup.sh /
RUN ./setup.sh
RUN rm /setup.sh
