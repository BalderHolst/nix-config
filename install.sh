#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git home-manager

stcolor="\u001b[34;1m"
scolor="\u001b[32;1m"
ecolor="\u001b[31;1m"
wcolor="\u001b[33;1m"
rcolor="\u001b[0m"

# Set the config directory
CONFIG_DIR="$HOME/.nix-config"

status () {
    echo -e "$stcolor""$@""$rcolor"
}

warning () {
    echo -e "$wcolor[WARNING]: ""$@""$rcolor"
}

error () {
    echo -e "$ecolor[ERROR]: ""$@""$rcolor"
}

# Clone config if it does not exist.
if [ ! -d "$CONFIG_DIR" ]
then
    status "Cloning configuration."
    git clone git@github.com:BalderHolst/nix-config "$CONFIG_DIR"
fi

# ============= Submodules =============
status "Checking out submodules."
git -C "$CONFIG_DIR" submodule update --init

# ============= Install System Config =============
status "Installing system configuration..."
warning "Script needs sudo permissions to perform system installation. PLEASE VERIFY THAT THIS SCRIPT IS NOT MALICIOUS."

# Rebuild system
sudo nixos-rebuild switch --flake "$CONFIG_DIR"#system || exit 1

# ============= Setup User =============

status "Installing user configuration..."
home-manager switch --flake "$CONFIG_DIR" || exit 1

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
