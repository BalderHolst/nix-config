{ pkgs, lib, config, ... }:
let
    cfg = config.typst;
    typst-package-check = pkgs.callPackage ../../pkgs/typst-package-check.nix {};
in
{

    options.typst = {
        enable = lib.mkEnableOption "Typst support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            typst
            tinymist
            typst-package-check
        ];
    };
}
