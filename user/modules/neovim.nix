{ pkgs, lib, config, ... }:
let
    n-shortcut = pkgs.writeShellScriptBin "n" ''
        nvim "$(${pkgs.fzf}/bin/fzf)"
    '';
in
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

        programs.neovide = {
            enable = true;
            settings = {
                fork = false;
                frame = "full";
                idle = true;
                maximized = false;
                neovim-bin = "nvim";
                no-multigrid = false;
                srgb = false;
                tabs = true;
                theme = "auto";
                title-hidden = true;
                vsync = true;
                wsl = false;

                font = {
                    normal = [];
                    size = 14.0;
                };
            };
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
            VISUAL = "neovide";
            VHDL_LS_CONFIG = "${vhdl_ls_config}";
        };

        home.packages = with pkgs; [
            n-shortcut                            # shortcut to open nvim with fzf
            tree-sitter                           # used by nvim-treesitter
            vscode-extensions.vadimcn.vscode-lldb # lldb vscode extension used in neovim
            rust-analyzer                         # lsp for rust
            nodejs                                # used by copilot
            pyright                               # python lsp
            lua-language-server                   # lsp for lua
            matlab-language-server                # lsp for matlab
            nixd                                  # lsp for nix
            clang-tools                           # lsp for c/c++
            yarn                                  # For markdown preview plugin
            nodePackages.npm                      # For markdown preview plugin
        ];

        home.file.".config/nvim/plugin/init.lua".text = (if config.neovim.neo-keymaps then ''
            vim.cmd('set langmap=jn,nj,ke,ek')
        '' else "");
    };
}
