#!/usr/bin/env bash

ZIP_FILE="$1"

if [ -z "$ZIP_FILE" ]; then
    echo "Usage: $0 <zip-file>"
    exit 1
fi

# Unzip installer
[ -d matlab-installer ] && rm -rf matlab-installer
unzip -d matlab-installer "$1"

# Run installer with correct enviornment
nix run gitlab:doronbehar/nix-matlab#matlab-shell
