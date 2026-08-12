{ pkgs, lib, config, ... }:
let
    cfg = config.typst;
in
{

    options.typst = {
        enable = lib.mkEnableOption "Typst support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            typst
            tinymist
        ];
    };
}
