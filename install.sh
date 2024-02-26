#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git home-manager fzf

# Set the config directory
CONFIG_DIR="$HOME/.nix-config"

status () {
    echo -e "\u001b[34;1m""$@""\u001b[0m"
}

warning () {
    echo -e "\u001b[33;1m[WARNING]: ""$@""\u001b[0m"
}

error () {
    echo -e "\u001b[31;1m[ERROR]: ""$@""\u001b[0m"
}

# ============= Clone Configuration =============
if [ ! -d "$CONFIG_DIR" ]
then
    status "Cloning configuration."
    git clone git@github.com:BalderHolst/nix-config "$CONFIG_DIR"
fi

# ============= Submodules =============
status "Checking out submodules."
git -C "$CONFIG_DIR" submodule update --init

# ============= Select Profile =============
PROFILE="$(ls ./profiles | fzf --prompt='Profile: ')"

[[ $PROFILE = "" ]] && {
    error "No profile chosen."
    exit 1
}

status "Chose profile: $PROFILE"; sleep 0.5

# ============= Install System Config =============
status "Installing system configuration..."
warning "Script needs sudo permissions to perform system installation. PLEASE VERIFY THAT THIS SCRIPT IS NOT MALICIOUS."

sudo cp -v /etc/nixos/hardware-configuration.nix "./profiles/$PROFILE/hardware-configuration.nix"

# Rebuild system
sudo nixos-rebuild switch --flake "$CONFIG_DIR"#$PROFILE || {
    error "\nErrored while building system configuration."
    exit 1
}

# ============= Setup User =============

status "Installing user configuration..."
nix run home-manager/master \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes -- \
    switch --flake $CONFIG_DIR#$PROFILE;

# ============= Neovim =============
status "Installing Neovim configuration..."
nvim_dir="$HOME/.config/nvim"

if [ ! -d "$nvim_dir" ]
then
    status "Getting Neovim configuration."
    git clone 'git@github.com:BalderHolst/neovim-config' "$nvim_dir"
else
    warning "Could not install NeoVim config, as one already exists."
fi

status "DONE!"
