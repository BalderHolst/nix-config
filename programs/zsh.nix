{ pkgs, config, configDir, ... }:
let
  exa = pkgs.eza + "/bin/eza";
  configDir = "~/.nix-config"; # TODO: make dependent on argument
in 
{

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        localVariables = {
            POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;
        };
        shellAliases = {

            ll = "${exa} -l";
            ls = "${exa}";
            r = "${pkgs.lf}/bin/lf";
            t = "kitty --detach";
            zathura = "${pkgs.zathura}/bin/zathura --fork";

            # Git
            gs = "git status";
            gc = "git commit";
            gp = "git push";
            gu = "git pull && git push";
            gaa = "git add .";
            gca = "git add . && git commit";

            uhome = "home-manager switch --flake ${configDir}";
            uos = "sudo nixos-rebuild switch --flake ${configDir}#system && home-manager switch --flake ${configDir}";

            hdmi-dublicate = "xrandr --output DisplayPort-0 --auto --same-as eDP";
        };
        history = {
            size = 10000;
            path = "${config.xdg.dataHome}/zsh/history";
        };

        # zsh plugins
        plugins = [
              {
                name = "zsh-nix-shell";
                file = "nix-shell.plugin.zsh";
                src = pkgs.fetchFromGitHub {
                  owner = "chisui";
                  repo = "zsh-nix-shell";
                  rev = "v0.7.0";
                  sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
                };
              }
            ];
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
        PATH="$PATH"":${../utils}"

        # Display incomplete todos
        todos="$(todo list)"
        [ "$todos" = "" ] || {
            echo "TODO:"
            while IFS= read -r task; do
                echo "$task"
            done <<< $todos
        }
        '';
    };

    home.file = {
        ".p10k.zsh".source = ../configs/p10k.zsh;
    };

    home.sessionVariables = {
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD = "true";
    };

}
