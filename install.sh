#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git home-manager 

stcolor="\u001b[34;1m"
scolor="\u001b[32;1m"
ecolor="\u001b[31;1m"
wcolor="\u001b[33;1m"
rcolor="\u001b[0m"

status () {
    echo -e "$stcolor""$@""$rcolor"
}

warning () {
    echo -e "$wcolor[WARNING]: ""$@""$rcolor"
}

error () {
    echo -e "$ecolor[ERROR]: ""$@""$rcolor"
}

prompt () {
    echo -n "> "
}

status "Installing..."

# ============= Submodules =============
status "Checking out submodules."
git submodule update --init

# ============= Neovim =============
nvim_dir="$HOME/.config/nvim"

if [ ! -d "$nvim_dir" ]
then
    status "Getting Neovim configuration."
    git clone 'git@github.com:BalderHolst/neovim-config' "$nvim_dir"
else
    warning "Could not install NeoVim config, as one already exists."
fi

# ============= Setup User =============

echo -e "\nI need a few informations to continue, press enter for default:"

# Theme
default="lake"
echo "Theme (default: '$default'):"
prompt
read theme
[ "$theme" = "" ] && theme="$default"

# Git username
default="BalderHolst"
echo "Git username (default: '$default'):"
prompt
read username
[ "$username" = "" ] && username="$default"

# Git email
default="balderwh@gmail.com"
echo "Git email (default: '$default'):"
prompt
read email
[ "$email" = "" ] && email="$default"

echo -e "{
    username = \"$USER\";
    theme = \"$theme\";
    git_username = \"$username\";
    git_email = \"$email\";
}" > user.nix

# ============= Install System Config =============
home_manager_dir="$HOME/.config/home-manager"
echo -e "\nScript needs sudo permissions to perform system installation.\nWARNING: PLEASE VERIFY THAT THE SCRIPT IS NOT MALICIOUS."

# Remove the old `configuration.nix` file
sudo rm "/etc/nixos/configuration.nix"

# Link the system configuration files
sudo ln -s "$home_manager_dir/nixos/configuration.nix" "/etc/nixos/configuration.nix"
[ ! -d "/etc/nixos/pkgs" ] && sudo ln -s "$home_manager_dir/pkgs" "/etc/nixos/pkgs"

# Add file specifying the admin user.
echo -e "\"$USER\"" > admin-user.nix
sudo chown root admin-user.nix
sudo mv admin-user.nix /etc/nixos/admin-user.nix

# Rebuild system
sudo nixos-rebuild switch

status "\nInstalling user configuration files."
home-manager switch || {
    error "\nSomething whent wrong while setting up user settings. Have you selected a valid theme? (check the README for valid themes)"
    exit 1
}

status "DONE!"
