#!/bin/sh

set -eu

# ensure the community repo is enabled (docker lives there)
sed -i '/^#.*\/community$/s/^#//' /etc/apk/repositories

apk update
apk add --no-cache \
    cloud-init cloud-init-openrc \
    doas mount \
    openssh-server-pam \
    docker \
    curl git tmux e2fsprogs-extra

# replace mdev with eudev: provides /dev/virtio-ports/* for qemu-guest-agent
setup-devd udev

# rebuild the OpenRC dependency tree so it includes the udev services
/usr/libexec/rc/bin/rc-depend -u

# sshd refuses key logins for locked accounts unless PAM is used
printf 'UsePAM yes\n' > /etc/ssh/sshd_config.d/10-pam.conf

# wheel may run commands as root without a password
printf 'permit nopass :wheel\n' > /etc/doas.d/20-wheel.conf

rc-update add cloud-init-local boot
rc-update add cloud-init default
rc-update add cloud-config default
rc-update add cloud-final default

rc-update add cgroups boot
rc-update add docker default
