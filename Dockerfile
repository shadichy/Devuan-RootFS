FROM devuan/migrated:excalibur-slim

COPY template /
COPY packages /
COPY setup.sh /

RUN apt update && apt upgrade -y

# Install additional apt utils 
RUN apt install -y apt-transport-https ca-certificates

# Install package list
RUN grep -Ev '^#' /pkglist.cfg | xargs apt install -y --no-install-recommends --no-install-suggests

# Generate a grub-rescue iso so we can use it as the base for the iso
RUN grub-mkrescue -o /grub-rescue.iso

# Try to strip down the image further
RUN grep -Ev '^#' /rmlist.cfg | xargs dpkg --remove --force-depends --force-remove-essential || :

RUN rm /*.cfg

RUN /setup.sh
RUN rm /setup.sh
