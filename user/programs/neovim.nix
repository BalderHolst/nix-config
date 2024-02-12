{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
    };

    home.sessionVariables = {
        EDITOR = "nvim";
    };

    home.packages = with pkgs; [
        vscode-extensions.vadimcn.vscode-lldb # lldb vscode extension used in neovim
        rust-analyzer # lsp for rust
        nodejs # local javascript runtime, mainly for pyright lsp
        nodePackages_latest.pyright # python lsp
        lua-language-server # lsp for lua
        rocmPackages.llvm.clang-tools-extra # contains clangd
    ];
}
