# Install with Flakes
Run the following command on any NixOs machine.

```bash
nix run github:BalderHolst/nix-config#install \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes
```

# Install with Shell

First run this command:

```bash
nix-shell -p git
```

This will open a shell with `git` installed.

Now run the following commands:

NOTE: Part of this script requires `sudo` privileges. Please review the script before running!

```bash
git clone https://github.com/BalderHolst/nix-hyprland-config ~/.config/home-manager
~/.config/home-manager/install.sh
```

After running the script a few things can need to be done.
1. Edit the `local.nix` file, and run `uhome` to apply your changes.
2. Open Neovim and run `PackerSync` to download and install all the plugins.
