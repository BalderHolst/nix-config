{ pkgs, lib, config, ... }:
let
    cfg = config.cad;
in
{

    options.cad = {
        enable = lib.mkEnableOption "CAD development tools";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            freecad-wayland
            prusa-slicer
        ];
    };
}
