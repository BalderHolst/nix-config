#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

stcolor="\u001b[34;1m"
scolor="\u001b[32;1m"
ecolor="\u001b[31;1m"
wcolor="\u001b[33;1m"
rcolor="\u001b[0m"

home_manager_dir="$HOME/.config/home-manager"

status () {
    echo -e "$stcolor""$@""$rcolor"
}

warning () {
    echo -e "$wcolor[WARNING]: ""$@""$rcolor"
}

error () {
    echo -e "$ecolor[ERROR]: ""$@""$rcolor"
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

# ============= Install System Config =============
warning "Script needs sudo permissions to perform system installation. PLEASE VERIFY THAT THE SCRIPT IS NOT MALICIOUS."

# Backup the old `configuration.nix` file
sudo cp "/etc/nixos/configuration.nix" "/etc/nixos/configuration.nix.bak"

# Link the system configuration files
sudo cp -v "$home_manager_dir/nixos/configuration.nix" "/etc/nixos/configuration.nix"
[ ! -d "/etc/nixos/pkgs" ] && sudo ln -s "$home_manager_dir/pkgs" "/etc/nixos/pkgs"

# Add file specifying the admin user.
echo -e "\"$USER\"" > admin-user.nix
sudo chown root admin-user.nix
sudo mv admin-user.nix /etc/nixos/admin-user.nix

# Rebuild system
sudo nixos-rebuild switch

# ============= Setup User =============

# Use hyprctl to get the main monitor
monitor=$(hyprctl monitors | head -n 1 | cut -d " " -f2 || echo "")

status "Creating \`user.nix\`."
echo -e "{
    username = \"balder\";
    theme = \"lake\";
    git_username = \"BalderHolst\";
    git_email = \"balderwh@gmail.com\";
    swap_escape = false;
    monitor = \"$monitor\";
}" > $home_manager_dir/user.nix

status "Installing user configuration files."
home-manager switch || exit 1

status "DONE!"
