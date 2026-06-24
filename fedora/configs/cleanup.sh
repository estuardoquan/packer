#!/bin/bash
set -euxo pipefail

# clean cloud-init state
cloud-init clean --machine-id --seed
rm -rf /var/lib/cloud/instances/* /var/lib/cloud/data/*

# remove image identifiers
rm -f /etc/hostname /etc/ssh/ssh_host_* /var/lib/systemd/random-seed
truncate -s 0 /etc/machine-id

# wipe authorized keys for root
truncate -s 0 /root/.ssh/authorized_keys

# harden sshd
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
