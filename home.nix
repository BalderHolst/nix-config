{ config, inputs, pkgs, ... }:

let
    user = import ./local.nix;
    username = user.username;
    theme = (import ./themes.nix )."${user.theme}";
    size = s: builtins.toString (builtins.floor s * user.ui_scale);
in
rec {
    nixpkgs = {
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
    };
    home.homeDirectory = "/home/${username}";
    home.username = username;

    imports = [
        ./programs/git.nix
        ./programs/neovim.nix
        ./programs/zsh.nix
        ./programs/cli-collection.nix
        ./programs/dev-collection.nix
        ./programs/desktop-collection.nix
        ./programs/school-collection.nix
        ( import ./vm/hyprland.nix { inherit theme user pkgs inputs builtins; } )
        ( import ./programs/firefox.nix { inherit username pkgs inputs; } )
    ];

    home.packages = with pkgs; [
        wl-clipboard # cli clipboard manipulation. Also needed for neovim.
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
