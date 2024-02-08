{ pkgs, ... }:
{
    home.packages = with pkgs; [
        zsh # better bash
        fish # shell for the 90s!
        kitty # terminal emulator
        gf # gdb fontend
        lazygit # git tui

        gnumake # make
        cmakeMinimal # cmake
        gnat13 # GNU compilers 

        gf # gdb fontend
        gdb # debugger
        lldb_9 # another debugger

        python311 # Python interpreter
        python311Packages.bpython

        rustc # the rust compiler
        cargo # rust build toolchain
        rustfmt # rust formatter
        clippy # rust linter
        cargo-expand # Expand macroes
    ];

    home.file = {
        ".config/kitty/kitty.conf".source = ../configs/kitty.conf;
    };
}
