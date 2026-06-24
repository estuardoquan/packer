#!/bin/sh

# Install essential packages:
# git, iperf3, wireguard-tools, tmux, neovim, stow
curl https://raw.githubusercontent.com/estuardoquan/post-install-scripts/refs/heads/main/fedora_install_essentials.sh | sh

# Install Docker
# 
curl https://raw.githubusercontent.com/estuardoquan/post-install-scripts/refs/heads/main/fedora_install_docker.sh | sh


systemctl enable docker
# Install Resolved
#
curl https://raw.githubusercontent.com/estuardoquan/post-install-scripts/refs/heads/main/fedora_install_systemd-resolved.sh | \
    RESOLVED_DOMAINS=local \
    RESOLVED_DNS=10.16.0.16 \
    RESOLVED_FALLBACK=10.16.0.15 \
    sh

# Install Hostname tools
#
curl https://raw.githubusercontent.com/estuardoquan/post-install-scripts/refs/heads/main/fedora_install_hostname-tools.sh | sh

systemctl enable hostname-watch.path
# Install Step CA Root certificate
#
curl https://raw.githubusercontent.com/estuardoquan/post-install-scripts/refs/heads/main/fedora_install_certificate.sh | \
    CA_TARGET=https://10.15.0.6/roots.pem \
    sh
