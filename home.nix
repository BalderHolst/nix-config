{ config, inputs, pkgs, ... }:

let
    user = import ./local.nix;
    username = user.username;
    theme = (import ./themes.nix )."${user.theme}";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    home.packages = with pkgs; [
        (callPackage ./pkgs/matlab-icon.nix { home = home; }) # Desktop icon for matlab
        (callPackage ./pkgs/bmark.nix { }) # bmark, my terminal bookmark manager

        # ====== CLI ======
        neofetch
        tldr # shot and sweet command examples
        zip # zip your files
        unzip # unzip your files

        # ====== General ======
        firefox-wayland # main browser
        brave # backup browser
        syncthing # synchronize files with my other computers
        libreoffice # office suite to open those awful microsoft files
        zathura # pdf-viewer
        sxiv # image viewer
        mpv # audio player
        vlc # video player
        gnome.nautilus # gui file explorer
        vifm # terminal file explorer
        audacity # audio editor
        gnome.eog # svg viewer
        texlive.combined.scheme-full # latex with everything
        python311Packages.pygments # syntax highlighter for minted latex package
        python311Packages.dbus-python # used for initializing eduroam
        gimp # image manipulation
        drawio # create diagrams
        tidal-hifi # music streaming
        grim # screenshot tool
        slurp # screen area selection tool
        imagemagick # cli image manipulation
        swappy # gui screenshot editor
        wf-recorder # screen recorder
        filezilla # ftp gui interface
        kicad # design pcd's and draw circuits
        prusa-slicer # slicer for 3d printing
        tor-browser-bundle-bin # secure and anonymous browsing
        protonup-qt # play windows games

        # password manager
        (pass-wayland.withExtensions (exts: [
          exts.pass-update
          exts.pass-checkup
          exts.pass-genphrase
        ]))

        # ====== Development ======
        git # you know why
        zsh # better bash
        fish # shell for the 90s!
        ripgrep # awesome grepping tool
        kitty # terminal emulator
        cutecom # serial terminal

        gnumake # make
        cmakeMinimal # cmake
        gnat13 # GNU compilers 
        python311 # Python interpreter

        rustc # the rust compiler
        cargo # rust build toolchain
        rustfmt # rust formatter
        rust-analyzer # lsp for rust
        clippy # rust linter

        lua-language-server # lsp for lua

        avrdude # burn programs to avr platforms
        avrdudess # GUI for avr-dude
        # pkgsCross.avr.buildPackages.gcc # gnu avr compilers

        arduino # arduino ide
        arduino-cli # arduino ide

        # ====== Study ======
        obsidian # note taking

        # ====== Other ======
        wl-clipboard # cli clipboard manipulation. Also needed for neovim.

    ];

    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
    };

    # Programs config
    programs = {

        firefox = {
            enable = true;
            profiles."${username}" = {
                bookmarks = [
                    {
                        name = "Nixos Packages";
                        tags = [ "nixos" ];
                        keyword = "nixpkgs";
                        url = "https://search.nixos.org/packages";
                    }
                    {
                        name = "SDU Email";
                        tags = [ "school" ];
                        keyword = "sdu";
                        url = "https://outlook.office.com/";
                    }
                    {
                        name = "SDU Itslearning";
                        tags = [ "school" ];
                        keyword = "itslearning";
                        url = "https://sdu.itslearning.com/";
                    }
                ];
                search.engines = {
                    "Nix Packages" = {
                        urls = [{
                            template = "https://search.nixos.org/packages";
                            params = [
                                { name = "type"; value = "packages"; }
                                { name = "query"; value = "{searchTerms}"; }
                            ];
                        }];
                        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        definedAliases = [ "!np" "!nix" "!nixpkgs" ];
                    };
                    "Crates.io" = {
                        urls = [{
                            template= "https://crates.io/search";
                            params = [
                                { name = "q"; value = "{searchTerms}"; }
                            ];
                        }];
                        icon = builtins.fetchurl {
                          url = "https://crates.io/assets/cargo.png";
                          sha256 = "sha256:1x254p99awa3jf1n617dn997aw44qv41jkfinhfdg9d3qblhkkr6";
                        };
                        definedAliases = [ "!rust" "!cargo" "!crate" "!crates" ];
                    };
                    "PyPI" = {
                        urls = [{
                            template= "https://pypi.org/search";
                            params = [
                                { name = "q"; value = "{searchTerms}"; }
                            ];
                        }];
                        icon = builtins.fetchurl {
                          url = "https://pypi.org/static/images/logo-small.2a411bc6.svg";
                          sha256 = "sha256:12ydpzmbc1a2h4g1gjk8wi02b3vkfqg84zja2v4c403iqdyi5xzr";
                        };
                        definedAliases = [ "!py" "!pypi" ];
                    };
                    "ProtonDB" = {
                        urls = [{
                            template= "https://www.protondb.com/search";
                            params = [
                                { name = "q"; value = "{searchTerms}"; }
                            ];
                        }];
                        icon = builtins.fetchurl {
                          url = "https://www.protondb.com/sites/protondb/images/favicon-32x32.png";
                          sha256 = "sha256:06fa36flrakdrkywvayqzcqid8g3mdq05f61r2mj05lfjmh3cygv";
                        };
                        definedAliases = [ "!proton" ];
                    };
                };
                search.force = true;
                extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
                    ublock-origin
                    vimium
                ];
            };
        };

    };

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
    ".config/waybar/config".text = ''
        {
            "height": ${size 24},
            "spacing": ${size 10},
    '' + builtins.readFile ./configs/waybar/config;

    ".config/waybar/style.css".text = ''
        @define-color background #${theme.background};
        @define-color foreground #${theme.foreground};
        @define-color primary #${theme.primary};
        @define-color secondary #${theme.secondary};
        @define-color alert #${theme.alert};
        @define-color disabled #${theme.disabled};

        * {
            font-family: FiraCode Nerd Font;
            font-size: ${size 13}px;
        }
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

        ${if user.swap_escape then ''
            input {
                kb_options = caps:swapescape
            }
            '' else ""}
    '' + builtins.readFile ./configs/hyprland.conf;

    ".config/hypr/hyprpaper.conf".text = ''
    preload = ${theme.wallpaper}
    wallpaper = ${user.monitor}, ${theme.wallpaper}
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
    
    # vifm config
    ".config/vifm/colors".source = builtins.fetchGit {
        url = "https://github.com/vifm/vifm-colors";
        ref = "master";
        rev = "3a1a04c370e1b6ed94c5b1d2791bc895ee733afb";
    };
    ".config/vifm/vifmrc".text = ''
        colorscheme afterglow
    '';

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
            r = "vifm";
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
