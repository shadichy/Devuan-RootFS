FROM devuan/migrated:ceres-slim

COPY template /
COPY packages /

COPY initrd /iso

COPY setup-initrd.sh /
COPY setup-rootfs.sh /

RUN apt update && apt upgrade -y

# Install additional apt utils 
RUN apt install -y apt-transport-https ca-certificates

# Re-run apt update after install apt utils
RUN apt update

# Install package list
RUN grep -Ev '^#' /pkglist.cfg | xargs apt install -y --no-install-recommends --no-install-suggests

# Install all busybox applets
RUN busybox --install -s /bin

# Generate initrd
RUN /setup-initrd.sh

# Try to strip down the image further
RUN grep -Ev '^#' /rmlist.cfg | xargs dpkg --remove --force-depends --force-remove-essential || :

RUN rm /*.cfg

RUN /setup-rootfs.sh
RUN rm /setup-rootfs.sh /setup-initrd.sh
