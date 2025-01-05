#!/bin/bash

# Install nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

# Enable flakes
echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf