# Install with Flakes
Run the following command on any NixOs machine.

```bash
nix run github:BalderHolst/nix-config#install \
    --extra-experimental-features nix-command \
    --extra-experimental-features flakes
```

# Install with Clone

Start by cloning the repository into `~/.nix-config`.

```bash
nix-shell -p git --command "git clone https://github.com/BalderHolst/nix-hyprland-config ~/.nix-config"
```

Now run the install script:

WARNING: Part of this script requires `sudo` privileges. Please review the script before running!

```bash
~/.nix-config/install.sh
```
