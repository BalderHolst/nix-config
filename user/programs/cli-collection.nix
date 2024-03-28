{ pkgs, ... }:
{
    home.packages = with pkgs; [
        neofetch # fancy system info
        tldr # shot and sweet command examples
        zip # zip your files
        unzip # unzip your files
        todo # simple todo list
        ripgrep # awesome grepping tool
        jq # json parsing cli
        bat # cat with colors
        wl-clipboard # cli clipboard manipulation. Also needed for neovim.
        bmark # my terminal bookmark manager
        blatex # my latex document framework
        fzf # fuzzy finder
        graphviz # create graphs!
        nurl # generate nix expressions from urls
        usbutils # list usb devices
        du-dust
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
