{ userName, userEmail, ... }:
{
    programs.git = {
        enable = true;
        userName = "balder";
        userEmail = "balderwh@gmail.com";
        aliases = {
            l = "log --oneline --graph";
            pp = "!git pull && git push";
            ignore = "!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi";
        };
        diff-so-fancy.enable = true;
        extraConfig = {
            init.defaultBranch = "main";
            pull.rebase = true;
        };
    };
}
