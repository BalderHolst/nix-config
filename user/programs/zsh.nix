{ pkgs, config, lib, ... }:
let
    exa = pkgs.eza + "/bin/eza";
    nh = pkgs.nh + "/bin/nh";
    oh-my-posh = pkgs.oh-my-posh + "/bin/oh-my-posh";
    oh-my-posh-config = pkgs.writeText "oh-my-posh-config.toml" ''
    #:schema https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json

    version = 2
    final_space = true
    console_title_template = '{{ .Shell }} in {{ .Folder }}'

    [[blocks]]
      type = 'prompt'
      alignment = 'left'
      newline = true

      [[blocks.segments]]
        type = 'path'
        style = 'plain'
        background = 'transparent'
        foreground = 'cyan'
        template = '{{ .Path }}'

        [blocks.segments.properties]
          style = 'full'

      [[blocks.segments]]
        type = 'git'
        style = 'plain'
        foreground = 'darkGray'
        background = 'transparent'
        template = ' {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</>'

        [blocks.segments.properties]
          branch_icon = ""
          commit_icon = '@'
          fetch_status = true

    [[blocks]]
      type = 'rprompt'
      overflow = 'hidden'

      [[blocks.segments]]
        type = 'executiontime'
        style = 'plain'
        foreground = 'yellow'
        background = 'transparent'
        template = '{{ .FormattedMs }}'

        [blocks.segments.properties]
          threshold = 5000

    [[blocks]]
      type = 'prompt'
      alignment = 'left'
      newline = true

      [[blocks.segments]]
        type = 'text'
        style = 'plain'
        foreground_templates = [
          "{{if gt .Code 0}}red{{end}}",
          "{{if eq .Code 0}}lightMagenta{{end}}",
        ]
        background = 'transparent'
        template = '❯'

    [transient_prompt]
      foreground_templates = [
        "{{if gt .Code 0}}red{{end}}",
        "{{if eq .Code 0}}magenta{{end}}",
      ]
      background = 'transparent'
      template = '❯ '

    [secondary_prompt]
      foreground = 'lightMagenta'
      background = 'transparent'
      template = '❯❯ '
    '';
in 
{
    options.zsh.configDir = lib.mkOption {
        type = lib.types.str;
    };

    config = {
        programs.zsh = {
            enable = true;
            enableCompletion = true;
            localVariables = {
                POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true;
            };
            shellAliases = rec {

                ll = "${exa} -l";
                lo = "${exa}";
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

                uhome = "nh home switch ${config.zsh.configDir} --configuration $(hostname)";
                uos = "${nh} os switch ${config.zsh.configDir} -H $(hostname) && ${uhome}";

                hdmi-dublicate = "xrandr --output DisplayPort-0 --auto --same-as eDP";

                direnv-flake = "echo 'use flake' > .envrc && direnv allow";
                direnv-nix = "echo 'use nix' > .envrc && direnv allow";
            };
            history = {
                size = 10000;
                path = "${config.xdg.dataHome}/zsh/history";
            };

            # zsh plugins
            plugins = [
                 #{
                 #  name = "zsh-nix-shell";
                 #  file = "nix-shell.plugin.zsh";
                 #  src = pkgs.fetchFromGitHub {
                 #    owner = "chisui";
                 #    repo = "zsh-nix-shell";
                 #    rev = "v0.7.0";
                 #    sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
                 #  };
                 #}
                ];
            zplug = {
                enable = true;
                plugins = [
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

            # Initialize oh-my-posh prompt
            eval "$(${oh-my-posh} init zsh --config ${oh-my-posh-config})"

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

        programs.direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
        };

        home.sessionVariables = {
            ZSH_DISABLE_COMPFIX = "true";
        };

    };
}
