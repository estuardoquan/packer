#!/bin/sh

set -eu

apt-get update
apt-get install -y --no-install-recommends \
    git tmux iperf3 stow \
    open-iscsi nfs-common apparmor

systemctl enable iscsid

# k3s binary and unit only — no start, no enable, no cluster identity
curl -sfL https://get.k3s.io -o /tmp/k3s-install.sh

INSTALL_K3S_VERSION=v1.36.4+k3s1 \
    INSTALL_K3S_SKIP_START=true \
    INSTALL_K3S_SKIP_ENABLE=true \
    sh /tmp/k3s-install.sh

rm -f /tmp/k3s-install.sh
