{ config, inputs, pkgs, ui_scale, configDir, ... }:

let
    username = "balder";
    swap_escape = false;
    monitor = "HDMI-A-1";
    ui_scale = 1.5;
    theme = import ../../themes/firewatch.nix;
    size = n: builtins.toString (builtins.floor n*ui_scale);
in
rec {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = (_: true);

    home.homeDirectory = "/home/${username}";
    home.username = username;

    imports = [
        ( import ../../user/programs/git.nix { userName = "BalderHolst"; userEmail = "balderwh@gmail.com"; } )
        ../../user/programs/neovim.nix
        ../../user/programs/pass.nix
        (import ../../user/programs/zsh.nix { inherit pkgs config configDir; } )
        ../../user/programs/cli-collection.nix
        ../../user/programs/dev-collection.nix
        ../../user/programs/desktop-collection.nix
       #../../user/programs/school-collection.nix
        ( import ../../user/vm/hyprland.nix { inherit theme swap_escape monitor pkgs inputs builtins size; } )
        ( import ../../user/programs/firefox.nix { inherit username pkgs inputs; } )
    ];

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
