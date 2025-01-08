{ pkgs, user, ... }:
let
    extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-python.python
        asvetliakov.vscode-neovim
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
            name = "lushay-code";
            publisher = "lushay-labs";
            version = "0.0.18";
            sha256 = "sha256-IEhdyb0s2ZzZc5Hx+PetsPVqNsWGdznTEDv9CX54DsA=";
        }
        {
            name = "vhdl-by-vhdlwhiz";
            publisher = "vhdlwhiz";
            version = "1.3.7";
            sha256 = "sha256-F/YWOW4aD+XEm0sol88vUbDckCaiFvWW6reCdzVVjFQ=";
        }
    ];
    home-dir = "/home/${user.username}";
    neovim-config-file = "${home-dir}/.config/VSCodium/User/nvim/init.lua";
    my-vscodium = (pkgs.stdenv.mkDerivation {
        name = "vscodium";
        src = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = extensions;
        };

        installPhase = ''
            mkdir -p $out
            cp -r * $out
            ln -s $out/bin/codium $out/bin/vscodium
            ln -s $out/bin/codium $out/bin/code
            '';
    });
in
{
    home.packages = [ my-vscodium ];

    home.file."${home-dir}/.config/VSCodium/User/settings.json".text = /* json */ ''
        {
            "editor.fontFamily": "Fira Code",
            "editor.fontLigatures": true,
            "editor.fontSize": 14,
            "editor.formatOnSave": true,
            "editor.renderWhitespace": "all",
            "editor.rulers": [80, 120],
            "editor.tabSize": 4,
            "editor.wordWrap": "on",
            "files.autoSave": "onWindowChange",
            "files.autoSaveDelay": 1000,
            "files.insertFinalNewline": true,
            "files.trimTrailingWhitespace": true,
            "workbench.colorTheme": "Lushay",
            "workbench.iconTheme": "vscode-icons",
            "workbench.startupEditor": "newUntitledFile",
            "vscode-neovim.neovimExecutablePaths.linux" : "${pkgs.neovim}/bin/nvim",
            "vscode-neovim.neovimInitVimPaths.linux" : "${neovim-config-file}",
            "keyboard.dispatch": "keyCode",
            "lushay.OssCadSuite.path": "${pkgs.callPackage ../../pkgs/oss-cad-suite.nix { }}/bin"
        }
        '';

    home.file."${neovim-config-file}".text = ''
    print("Hello, world!")
    '';
}
