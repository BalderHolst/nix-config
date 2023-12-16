{ pkgs, ... }:
{
    home.packages = with pkgs; [
        neofetch # fancy system info
        tldr # shot and sweet command examples
        zip # zip your files
        unzip # unzip your files
        todo # simple todo list
        ripgrep # awesome grepping tool
        bat # cat with colors
        wl-clipboard # cli clipboard manipulation. Also needed for neovim.
        (callPackage ../pkgs/bmark.nix { }) # my terminal bookmark manager
        (callPackage ../pkgs/blatex.nix { }) # my latex document framework
    ];

    home.sessionVariables = {
        PAGER = "bat";
    };

    home.file = {

        # Bmark config
        ".config/bmark/config.toml".text = ''
        data_dir = "/home/balder/.local/share/bmark"
        dmenu_cmd = "rofi -matching fuzzy -dmenu"
        editor_cmd = "nvim"
        terminal_cmd = "kitty --detach -d"
        alias_prefix = "_"
        display_sep = " : "
        '';

    };
}
