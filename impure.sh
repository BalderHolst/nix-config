#!/usr/bin/env bash

echo -e "\nRunning impure setup script."

# ============= Neovim =============

nvim_dir="$HOME/.config/nvim"

if [ ! -d "$nvim_dir/.git" ]
then
    echo "Getting Neovim configuration."
    [ -d $nvim_dir ] &&  rm -rfv "$nvim_dir"
    git clone https://github.com/BalderHolst/neovim-config "$HOME/.config/nvim"
fi

echo "Impure setup complete."
