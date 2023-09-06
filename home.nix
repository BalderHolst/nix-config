{ config, pkgs, ... }:

let
    user = import ./user.nix;
    username = user.username;
    theme = (import ./themes.nix )."${user.theme}";
in
rec {
    home.homeDirectory = "/home/${username}";
    home.username = username;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; let
        matlabIcon = makeDesktopItem {
            name = "matlab";
            desktopName = "Matlab";
            exec = "${home.homeDirectory}/.config/home-manager/utils/matlab -desktop";
            icon = builtins.fetchurl {
                url = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Matlab_Logo.png/667px-Matlab_Logo.png";
                sha256 = "sha256:1379d2pdm49hcq9gib47jd7jrp2926h69an5jjgfh60rwnhgrslx";
            };
        };
    in
    [
        matlabIcon
        neofetch
    ];

    # Config files
    home.file = {

    # Nixpkgs config
    ".config/nixpkgs/config.nix".source = ./configs/nixpkgs.nix;

    # Swappy screenshot editing tool
    ".config/swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=sans-serif
    paint_mode=brush
    early_exit=true
    fill_shape=false
    '';

    # Powerlevel10k zsh prompt
    ".p10k.zsh".source = ./configs/p10k.zsh;

    # Rofi config
    ".config/rofi/config.rasi".source = ./configs/rofi.rasi;
    ".config/rofi/theme.rasi".text = ''
        * {
            bg: #${theme.background}80;
            bg-alt: #${theme.background};
            fg: #${theme.foreground};
            fg-alt: #${theme.primary};
        }
    '';

    # Bmark config
    ".config/bmark/config.toml".text = ''
        data_dir = "/home/balder/.local/share/bmark"
        dmenu_cmd = "rofi -matching fuzzy -dmenu"
        editor_cmd = "nvim"
        terminal_cmd = "kitty --detach -d"
        alias_prefix = "_"
        display_sep = " : "
    '';

    # Waybar config
    ".config/waybar/config".source = ./configs/waybar/config;
    ".config/waybar/style.css".text = ''
        @define-color background #${theme.background};
        @define-color foreground #${theme.foreground};
        @define-color primary #${theme.primary};
        @define-color secondary #${theme.secondary};
        @define-color alert #${theme.alert};
        @define-color disabled #${theme.disabled};
        '' + builtins.readFile ./configs/waybar/style.css;

    # Hyprland config
    ".config/hypr/hyprland.conf".text = ''
        general {
            gaps_in = 5
            gaps_out = 10
            border_size = 2
            col.active_border = rgb(${theme.focus})
            col.inactive_border = rgba(595959aa)
            layout = dwindle
        }
    '' + builtins.readFile ./configs/hyprland.conf;

    ".config/hypr/hyprpaper.conf".text = ''
    preload = ${theme.wallpaper}
    wallpaper = eDP-1, ${theme.wallpaper}
    '';

    ".config/zathura/zathurarc".text = ''
        set statusbar-h-padding 0
        set statusbar-v-padding 0
        set page-padding 1
        map d scroll half-down
        map u scroll half-up
        map R rotate
        map J zoom in
        map K zoom out
        map i recolor
        map p print
        set selection-clipboard clipboard
    '';

    # Kitty config
    ".config/kitty/kitty.conf".source = ./configs/kitty.conf;

    # Utility scripts
    ".myutils".source = ./utils;

    };

    programs.git = {
        enable = true;
        userName = user.git_username;
        userEmail = user.git_email;
        aliases = {
            l = "log --oneline --graph";
            ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
        };
        diff-so-fancy.enable = true;
        extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = true;
        };
    };

    programs.zsh = {
        enable = true;
        localVariables = {
            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;
        };
        shellAliases = {

            ll = "exa -l";
            ls = "exa";
            r = "ranger";
            t = "kitty --detach";

            # Git
            gs = "git status";
            gc = "git commit";
            gp = "git push";
            gaa = "git add .";
            gca = "git add . && git commit";

            hdmi-dublicate = "xrandr --output DisplayPort-0 --auto --same-as eDP";
        };
        history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
        };

        # zsh plugins
        zplug = {
            enable = true;
            plugins = [
                    { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
                    { name = "zsh-users/zsh-syntax-highlighting"; }
            ];
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "pass" ];
          theme = "robbyrussell";
        };

        initExtra = ''

        # Extra navigation aliases
        alias ..='cd ..'
        alias ...='cd ../..'

        # Source bookmarks file if it exists
        [ -f ~/.local/share/bmark/aliases.sh ] && source ~/.local/share/bmark/aliases.sh

        source ~/.p10k.zsh # Initialize powerlevel10k prompt

        # Add utils to PATH
        PATH="$PATH"":${home.homeDirectory}/.myutils"
        '';
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

    home.sessionVariables = {
        EDITOR = "nvim";
        PAGER = "bat";
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = "true";
    };

    xdg.mimeApps.defaultApplications = {
        "text/plain" = [ "nvim" ];
        "application/pdf" = [ "zathura.desktop" ];
        "image/*" = [ "sxiv.desktop" ];
        "audio/*" = [ "mpv.desktop" ];
        "video/*" = [ "mpv.desktop" ];
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
