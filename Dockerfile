FROM devuan/migrated:excalibur-slim

COPY template /
COPY packages /
COPY setup.sh /

RUN apt update && apt upgrade -y

# Install package list
RUN grep -Ev '^#' /pkglist.cfg | xargs apt install -y --no-install-recommends --no-install-suggests

# Replace stock system.jwmrc with ours
RUN mv /system.jwmrc /etc/jwm/system.jwmrc

# Install programs to generate grub-rescue.iso
RUN apt install xorriso mtools -y

# Generate a grub-rescue iso so we can use it as the base for the iso
RUN grub-mkrescue -o /grub-rescue.iso

# Remove xorriso once done
RUN apt remove xorriso mtools -y

# Try to strip down the image further
RUN grep -Ev '^#' /rmlist.cfg | xargs dpkg --remove --force-depends --force-remove-essential || :

RUN rm /*.cfg

RUN /setup.sh
RUN rm /setup.sh
