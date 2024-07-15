{ pkgs, lib, config, ... }:
let
    cfg = config.embedded.arduino;
in
{

    options.embedded.arduino = {
        enable = lib.mkEnableOption "Arduino support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            arduino # arduino ide
            arduino-cli # arduino ide
        ];
    };
}
