#!/bin/sh

set -eu

apt-get update
apt-get install -y --no-install-recommends \
    git tmux iperf3 stow
