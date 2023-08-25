#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

default_theme="lake"

echo "Installing..."

# ============= Neovim =============
nvim_dir="$HOME/.config/nvim"

if [ ! -d "$nvim_dir" ]
then
    echo "Getting Neovim configuration."
    [ -d $nvim_dir ] &&  rm -rfv "$nvim_dir"
    git clone https://github.com/BalderHolst/neovim-config "$HOME/.config/nvim"
fi

# ============= Setup User =============
echo -e "\nI need a few informations to continue, press enter for default/blank:"

# Theme
echo "Theme (default: '$default_theme'):"
echo -n "> "
read theme
[ "$theme" = "" ] && theme="$default_theme"

# Git username
echo "Git username:"
echo -n "> "
read username

# Git email
echo "Git email:"
echo -n "> "
read email

echo -e "{
    username = \"$USER\";
    theme = \"$theme\";
    git_username = \"$username\";
    git_email = \"$email\";
}" > user.nix

echo -e "\nInstalling user configuration files."
home-manager switch || {
    echo -e "\nSomething whent wrong while setting up user settings. Have you selected a valid theme? (check the README for valid themes)"
    exit 1
}

# ============= Install System Config =============
home_manager_dir="$HOME/.config/home-manager"
echo -e "\nScript need sudo permissions to perform system installation.\nWARNING: PLEASE VERIFY THAT THE SCRIPT IS NOT MALICIOUS."

# Give `root`-user ownership of the system configuration file.
sudo chown -R root nixos

# Remove the old `configuration.nix` file
sudo rm "/etc/nixos/configuration.nix"

# Link the system configuration files
sudo ln "$home_manager_dir/nixos/configuration.nix" "/etc/nixos/configuration.nix"
sudo ln -s "$home_manager_dir/nixos/pkgs" "/etc/nixos/pkgs"

# Add file specifying the admin user.
echo -e "\"$USER\"" > admin-user.nix
sudo chown root admin-user.nix
sudo mv admin-user.nix /etc/nixos/admin-user.nix

# Rebuild system
sudo nixos-rebuild switch

echo -e "DONE!"
