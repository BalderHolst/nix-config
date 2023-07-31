# Install

First run this command:

```bash
nix-shell -p git
```

This will open a shell with `git` installed.

Now run the following commands:

NOTE: Part of this script requires `sudo` privileges. Please review the script before running!

```bash
git clone https://github.com/BalderHolst/nix-hyprland-config ~/.config/home-manager
cd ~/.config/home-manager
./install.sh
```
