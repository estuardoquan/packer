#!/bin/sh

set -eu

# ensure the community repo is enabled (docker lives there)
sed -i '/^#.*\/community$/s/^#//' /etc/apk/repositories

apk update
apk add --no-cache \
    cloud-init cloud-init-openrc \
    docker docker-cli-compose \
    curl git tmux

rc-update add cloud-init-local boot
rc-update add cloud-init default
rc-update add cgroups boot
rc-update add docker default
