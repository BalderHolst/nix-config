{ pkgs, ... }:
{
    home.packages = with pkgs; [
        (vscode-with-extensions.override {
            vscode = vscodium;
            vscodeExtensions = with vscode-extensions; [
                bbenoist.nix
                ms-python.python
                vscode-extensions.vscodevim.vim
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
          })
    ];
}
