#!/bin/sh

set -eu

# clean cloud-init state
cloud-init clean --machine-id --seed || true
rm -rf /var/lib/cloud/instances/* /var/lib/cloud/data/*

# remove image identifiers
rm -f /etc/hostname /etc/ssh/ssh_host_* /var/lib/seedrng
truncate -s 0 /etc/machine-id

# wipe build key
truncate -s 0 /root/.ssh/authorized_keys

# clear apk cache
rm -rf /var/cache/apk/*
