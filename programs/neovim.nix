{ ... }:
{
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
    };

    home.sessionVariables = {
        EDITOR = "nvim";
    };
}
