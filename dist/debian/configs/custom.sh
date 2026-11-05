#!/bin/sh

set -eu

apt-get update
apt-get install -y \
    git neovim stow tmux
