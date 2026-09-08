#!/bin/sh
set -eu

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
    git tmux neovim iperf3 stow

# k3s binary and unit only — no start, no enable, no cluster identity
curl -sfL https://get.k3s.io | \
    INSTALL_K3S_VERSION=v1.36.4+k3s1 \
    INSTALL_K3S_SKIP_START=true \
    INSTALL_K3S_SKIP_ENABLE=true \
    sh -
