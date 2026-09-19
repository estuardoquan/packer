#!/bin/sh

set -eu

# ensure the community repo is enabled (docker lives there)
sed -i '/^#.*\/community$/s/^#//' /etc/apk/repositories

apk update
apk add --no-cache \
    cloud-init cloud-init-openrc \
    mount \
    docker \
    curl git tmux e2fsprogs-extra

# replace mdev with eudev: provides /dev/virtio-ports/* for qemu-guest-agent
setup-devd udev

rc-update add cloud-init-local boot
rc-update add cloud-init default
rc-update add cloud-config default
rc-update add cloud-final default

rc-update add cgroups boot
rc-update add docker default
