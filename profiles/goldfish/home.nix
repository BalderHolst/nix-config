{ user, config, inputs, pkgs, configDir, ... }:

let
    monitor = "eDP-1";
    theme = import ../../themes/lake.nix;
    ui_scale = 1;
    size = n: builtins.toString (builtins.floor n*ui_scale);
in
{
    home.homeDirectory = "/home/${user.username}";
    home.username = user.username;

    imports = [
        ../../user/modules
        ../../user/modules/steam.nix
        ../../user/modules/pass.nix
        ../../user/modules/cli-collection.nix
        ../../user/modules/desktop-collection.nix
        ../../user/vm/niri
        ../../user/modules/firefox
    ];

    git.userName = "BalderHolst";
    git.userEmail = user.email;

    zsh.configDir = configDir;

    niri = {
        inherit theme;
        inherit monitor;
        inherit size;
        swap_escape = true;
        disable_escape_led = true;
    };

    firefox.username = user.username;
    firefox.theme = "another_online";

    lang = {
        c.enable      = true;
        rust.enable   = true;
        python = {
            enable = true;
            notebooks = true;
        };
    };

    embedded = {
        arduino.enable = false;
        avr.enable     = false;
        tiva.enable    = false;
        yosys.enable   = false;
        pico.enable    = false;
    };

    latex.enable = true;
    typst.enable = true;

    pcb.enable = false;

    gtk.iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
    };

    # home.pointerCursor = {
    #     enable = true,
    #     gtk.enable = true;
    #     x11.enable = true;
    #     name = "Bibata-Original-Classic";
    #     size = 18;
    #     package = pkgs.bibata-cursors;
    # };

    gtk = {
        enable = true;
        font.name = "FiraCode Nerd Font";
        # theme = {
        #     name = "Sierra-compact-dark";
        #     package = pkgs.sierra-gtk-theme;
        # };
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
