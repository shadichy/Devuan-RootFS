FROM devuan/devuan:excalibur

COPY . /

RUN apt update && apt upgrade -y

RUN apt install htop fastfetch utillinux busybox -y
