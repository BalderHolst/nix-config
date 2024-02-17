{ lib, config, ... }:
{
    options.git.userName = lib.mkOption {
        type = lib.types.str;
    };
    options.git.userEmail = lib.mkOption {
        type = lib.types.str;
    };

    config.programs.git = {
        enable = true;
        userName = config.git.userName;
        userEmail = config.git.userEmail;
        aliases = {
            l = "log --oneline --graph";
            pp = "!git pull && git push";
            ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
            b = "blame -w -C -C -C";
        };
        diff-so-fancy.enable = true;
        extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = true;
            rerere.enabled = true;
            column.ui = "auto";
        };
    };
}
