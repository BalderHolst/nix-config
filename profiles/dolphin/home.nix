{ username, email, config, inputs, pkgs, configDir, ... }:

let
    swap_escape = false;
    monitor = "HDMI-A-1";
    theme = import ../../themes/firewatch.nix;
    size = n: builtins.toString (builtins.floor n*ui_scale);
    ui_scale = 1.5;
in
rec {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (_: true);
    nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

    home.homeDirectory = "/home/${username}";
    home.username = username;

    imports = [
        ../../user/programs/git.nix
        ../../user/programs/neovim.nix
        ../../user/programs/pass.nix
        ../../user/programs/zsh.nix
        ../../user/programs/cli-collection.nix
        ../../user/programs/dev-collection.nix
        ../../user/programs/desktop-collection.nix
        ../../user/vm/hyprland.nix
        ../../user/programs/firefox.nix
    ];

    git.userName = "BalderHolst";
    git.userEmail = email;

    zsh.configDir = configDir;

    hyprland = { inherit theme; inherit monitor; inherit size; inherit swap_escape; };

    firefox.username = username;


    gtk.iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
    };

    home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        name = "Bibata-Original-Classic";
        size = 18;
        package = pkgs.bibata-cursors;
    };

    gtk = {
        enable = true;
        font.name = "FiraCode Nerd Font";
        theme = {
            name = "Sierra-compact-dark";
            package = pkgs.sierra-gtk-theme;
        };
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
