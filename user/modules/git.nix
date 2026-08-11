{ pkgs, lib, config, ... }:
{
    options.git.userName = lib.mkOption {
        type = lib.types.str;
    };
    options.git.userEmail = lib.mkOption {
        type = lib.types.str;
    };

    config.programs.git = {
        enable = true;
        settings = {
            user = {
                name  = config.git.userName;
                email = config.git.userEmail;
            };
            aliases = {
                l = "log --oneline --graph";
                pp = "!git pull && git push";
                ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
                meld = ''!m() { ${pkgs.meld}/bin/meld "$(git rev-parse --show-toplevel)"; }; m &'';
                b = "blame -w -C -C -C";
                regret = "reset --soft HEAD~1";
                root = "rev-parse --show-toplevel";
            };
            extraConfig = {
                init.defaultBranch = "main";
                pull.rebase = true;
                push.autoSetupRemote = true;
                rerere.enabled = true;
                column.ui = "auto";
            };
        };
        # diff-so-fancy.enable = true;
        ignores = [ ];
    };
    config.programs.diff-so-fancy.enableGitIntegration = true;
}
