#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

echo "Installing..."

# ============= Neovim =============
nvim_dir="$HOME/.config/nvim"

if [ ! -d "$nvim_dir/.git" ]
then
    echo "Getting Neovim configuration."
    [ -d $nvim_dir ] &&  rm -rfv "$nvim_dir"
    git clone https://github.com/BalderHolst/neovim-config "$HOME/.config/nvim"
fi

# ============= Install System Config =============
echo -e "\nScript need sudo permissions to perform system installation.\nWARNING: PLEASE VERIFY THAT THE SCRIPT IS NOT MALICIOUS."
sudo rm "/etc/nixos/configuration.nix"
sudo ln "./configuration.nix" "/etc/nixos/configuration.nix" 
sudo nixos-rebuild switch

# ============= Run home-manager =============
echo -e "\nInstall configuration files."
home-manager switch

echo -e "DONE!"
