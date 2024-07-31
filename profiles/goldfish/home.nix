{ username, email, config, inputs, pkgs, configDir, system, ... }:

let
    swap_escape = true;
    monitor = "eDP-1";
    theme = import ../../themes/lake.nix;
    ui_scale = 1;
    size = n: builtins.toString (builtins.floor n*ui_scale);
in
rec {
    home.homeDirectory = "/home/${username}";
    home.username = username;

    imports = [
        ../../user/modules/git.nix
        ../../user/modules/neovim.nix
        ../../user/modules/steam.nix
        ../../user/modules/pass.nix
        ../../user/modules/zsh.nix
        ../../user/modules/cli-collection.nix
        ../../user/modules/development
        ../../user/modules/desktop-collection.nix
        ../../user/modules/school-collection.nix
        ../../user/vm/hyprland.nix
        ../../user/modules/firefox
    ];

    git.userName = "BalderHolst";
    git.userEmail = email;

    zsh.configDir = configDir;

    hyprland = { inherit theme; inherit monitor; inherit size; inherit swap_escape; };

    firefox.username = username;

    lang = {
        c.enable      = true;
        python.enable = true;
        rust.enable   = true;
    };

    embedded = {
        arduino.enable = false;
        avr.enable     = false;
        tiva.enable    = false;
        yosys.enable   = false;
    };

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
