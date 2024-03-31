{ pkgs, ... }:
{
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
    };

    home.sessionVariables =
    let
    vhdl_ls_config = pkgs.writeText "vhdl_ls.toml" ''
        # File names are either absolute or relative to the parent folder of the vhdl_ls.toml file
        [libraries]
        lib1.files = [
          'pkg1.vhd',
        ]
        '';
    in
    {
        EDITOR = "nvim";
        VHDL_LS_CONFIG = "${vhdl_ls_config}";
    };

    home.packages = with pkgs; [
        vscode-extensions.vadimcn.vscode-lldb # lldb vscode extension used in neovim
        rust-analyzer # lsp for rust
        nodejs # local javascript runtime, mainly for pyright lsp
        nodePackages_latest.pyright # python lsp
        lua-language-server # lsp for lua
        (callPackage ../../pkgs/clangd.nix { })
        (callPackage ../../pkgs/vhdl_ls.nix { })
    ];
}
