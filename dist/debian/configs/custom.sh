#!/bin/sh

set -eu

apt-get update
apt-get install -y --no-install-recommends \
    git neovim stow tmux
