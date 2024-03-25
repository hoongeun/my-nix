#!/usr/bin/env bash

sudo nixos-rebuild switch --flake .#system --impure
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#user;
