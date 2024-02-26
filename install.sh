#!/bin/sh

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

clone_github () {
    user="$1"
    repo="$2"
    dir="$3"

    # Clone repo
    nix-shell -p git --command "git clone https://github.com/$user/$repo '$dir'"

    # Change url to use ssh from now on
    nix-shell -p git --command "git -C '$dir' remote set-url origin git@github.com:$user/$repo"
}

# ============= Clone Configuration =============
if [ ! -d "$CONFIG_DIR" ]
then
    status "Cloning configuration."
    clone_github BalderHolst nix-config "$CONFIG_DIR"
fi

# ============= Submodules =============
status "Checking out submodules."
nix-shell -p git --command "git -C '$CONFIG_DIR' submodule update --init"

# ============= Select Profile =============
PROFILE="$( nix-shell -p fzf --command "ls $CONFIG_DIR/profiles | fzf --prompt='Profile: '" )"

[[ $PROFILE = "" ]] && {
    error "No profile chosen."
    exit 1
}

status "Chose profile: $PROFILE";

# ============= Install System Config =============
status "Installing system configuration..."
warning "Script needs sudo permissions to perform system installation. PLEASE VERIFY THAT THIS SCRIPT IS NOT MALICIOUS."

sudoo () {
    if [ "$(whoami)" = "root" ]
    then
        eval "$@"
    else
        eval "sudo $@"
    fi
}

if [ ! -e /etc/nixos/hardware-configuration.nix ]
then
    status "Generating hardware configuration."
    sudo nixos-generate-config
fi

sudoo cp -v /etc/nixos/hardware-configuration.nix "./profiles/$PROFILE/hardware-configuration.nix"

# Rebuild system
sudoo nixos-rebuild switch --flake "$CONFIG_DIR"#$PROFILE || {
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
    clone_github BalderHolst neovim-config "$nvim_dir"
else
    warning "Could not install NeoVim config, as one already exists."
fi

status "DONE!"
