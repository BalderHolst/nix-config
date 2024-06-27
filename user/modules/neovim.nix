{ pkgs, lib, config, ... }:
{
    options.neovim.neo-keymaps = lib.mkOption {
        type = lib.types.bool;
        default = false;
    };

    config = {
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
            nodejs # used by copilot
            pyright # python lsp
            lua-language-server # lsp for lua
            (callPackage ../../pkgs/clangd.nix { # clangd lsp with standard c library
                name = "clangd";
                include_paths = [ (pkgs.glibc.dev + "/include") ];
            })
            (callPackage ../../pkgs/vhdl_ls.nix { })
        ];

        home.file.".config/nvim/plugin/init.lua".text = (if config.neovim.neo-keymaps then ''
            vim.cmd('set langmap=jn,nj,ke,ek')
        '' else "");
    };
}
