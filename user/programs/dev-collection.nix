{ pkgs, ... }:
let
    # rust-toolchain = pkgs.rust-bin.selectLatestNightlyWith (toolchain: toolchain.default.override {
    #     extensions = [ "rust-src" ];
    #     targets = [ "arm-unknown-linux-gnueabihf" ];
    # });
    rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" ];
        targets = [ "arm-unknown-linux-gnueabihf" ];
    };
in
{

    imports = [
        ./vscode.nix
    ];

    home.packages = with pkgs; [
        zsh # better bash
        fish # shell for the 90s!
        kitty # terminal emulator
        gf # gdb fontend
        lazygit # git tui
        nix-index # search for files in nixpkgs

        gnumake # make
        cmakeMinimal # cmake
        gnat13 # GNU compilers 

        gf # gdb fontend
        gdb # debugger

        python311 # Python interpreter
        python311Packages.bpython

        rustc # the rust compiler
        cargo-expand
        rust-toolchain # rust build toolchain
        sqlitebrowser # sqlite browser
    ];

    home.file = {
        ".config/kitty/kitty.conf".text = ''
            background_opacity 0.6
            font_size 14.0
            font_family FiraCode Nerd Font

            enable_audio_bell no
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
}
