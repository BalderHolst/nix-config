{ config, pkgs, ... }:

{
    home.username = "balder";
    home.homeDirectory = "/home/balder";

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
        # # It is sometimes useful to fine-tune packages, for example, by applying
        # # overrides. You can do that directly here, just don't forget the
        # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
        # # fonts?
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

        # # You can also create simple shell scripts directly inside your
        # # configuration. For example, this adds a command 'my-hello' to your
        # # environment:
        # (pkgs.writeShellScriptBin "my-hello" ''
        #     echo "Hello, ${config.home.username}!"
        # '')
        neofetch
    ];

    # Config files
    home.file = {

    # Powerlevel10k zsh prompt
    ".p10k.zsh".text = builtins.readFile ./configs/p10k.zsh;

    ".config/waybar".source = ./configs/waybar;

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

    # Hyprland config
    ".config/hypr/hyprland.conf".text = builtins.readFile ./configs/hyprland.conf;

    # Kitty config
    ".config/kitty/kitty.conf".text = ''
        background_opacity 0.6
        font_size 12.0
        font_family FiraCode Nerd Font
        
        confirm_os_window_close 0
        
        shell zsh
        
        foreground #c0caf5
        selection_background #33467C
        selection_foreground #c0caf5
        url_color #73daca
        cursor #c0caf5
        
        # Tabs
        active_tab_background #7aa2f7
        active_tab_foreground #1f2335
        inactive_tab_background #292e42
        inactive_tab_foreground #545c7e
        #tab_bar_bkground #15161E
        
        # normal
        color0 #15161E
        color1 #f7768e
        color2 #9ece6a
        color3 #e0af68
        color4 #7aa2f7
        color5 #bb9af7
        color6 #7dcfff
        color7 #a9b1d6
        
        # bright
        color8 #414868
        color9 #f7768e
        color10 #9ece6a
        color11 #e0af68
        color12 #7aa2f7
        color13 #bb9af7
        color14 #7dcfff
        color15 #c0caf5
        
        # extendedolors
        color16 #ff9e64
        color17 #db4b4b
    '';
        
    };

    programs.git = {
        enable = true;
        userName = "BalderHolst";
        userEmail = "balderwh@gmail.com";
        aliases = {
            l = "log --oneline --graph";
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

            # Nixos
            uhome = "home-manager switch && ~/.config/home-manager/impure.sh";
            uos = "sudo nixos-rebuild switch && home-manager switch && ~/.config/home-manager/impure.sh";
            cos = "sudo nvim -c 110 /etc/nixos/configuration.nix";

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
        zplug = {
            enable = true;
            plugins = [
                    { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
                    { name = "zsh-users/zsh-syntax-highlighting"; }
            ];
        };
        initExtra = ''
        source ~/.p10k.zsh # Initialize powerlevel10k prompt

        # Archive Extraction
        ex ()
        {
          if [ -f "$1" ] ; then
            case $1 in
              *.tar.bz2)   tar xjf $1   ;;
              *.tar.gz)    tar xzf $1   ;;
              *.bz2)       bunzip2 $1   ;;
              *.rar)       unrar x $1   ;;
              *.gz)        gunzip $1    ;;
              *.tar)       tar xf $1    ;;
              *.tbz2)      tar xjf $1   ;;
              *.tgz)       tar xzf $1   ;;
              *.zip)       unzip $1     ;;
              *.Z)         uncompress $1;;
              *.7z)        7z x $1      ;;
              *.deb)       ar x $1      ;;
              *.tar.xz)    tar xf $1    ;;
              *.tar.zst)   unzstd $1    ;;
              *)           echo "'$1' cannot be extracted via ex()" ;;
            esac
          else
            echo "'$1' is not a valid file"
          fi
        }
        '';
    };

    gtk.iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
    };

    gtk = {
        enable = true;
        font.name = "FiraCode Nerd Font";
        theme = {
            name = "Adapta";
            package = pkgs.adapta-kde-theme;
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
