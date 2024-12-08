FROM devuan/migrated:ceres-slim

COPY template /
COPY packages /
COPY setup.sh /
COPY iso /iso

RUN apt update && apt upgrade -y

# Install additional apt utils 
RUN apt install -y apt-transport-https ca-certificates

# Re-run apt update after install apt utils
RUN apt update

# Install package list
RUN grep -Ev '^#' /pkglist.cfg | xargs apt install -y --no-install-recommends --no-install-suggests

# Generate a grub-rescue iso so we can use it as the base for the iso
RUN grub-mkrescue -o /grub-rescue.iso /iso
RUN rm -rf /iso

# Try to strip down the image further
RUN grep -Ev '^#' /rmlist.cfg | xargs dpkg --remove --force-depends --force-remove-essential || :

RUN rm /*.cfg

RUN /setup.sh
RUN rm /setup.sh
