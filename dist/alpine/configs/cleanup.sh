#!/bin/sh

set -eu

# clean cloud-init state
cloud-init clean --machine-id --seed
rm -rf /var/lib/cloud/instances/* /var/lib/cloud/data/*

# remove image identifiers
rm -rf /var/lib/seedrng
rm -f /etc/hostname /etc/ssh/ssh_host_* 
truncate -s 0 /etc/machine-id

# wipe build key
truncate -s 0 /root/.ssh/authorized_keys

# clear apk cache
rm -rf /var/cache/apk/*

# clear saved OpenRC dependency tree; clones generate a fresh one on first boot
rm -rf /var/cache/rc/*
