#!/usr/bin/env bash

name=$1

[[ "$name" = "" ]] && {
    echo "Please supply a file."
    exit 1
}

set -xe

nix-store --query --hash $(nix store add-path "$name" --name "$name")
