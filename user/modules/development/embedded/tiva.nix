{ pkgs, lib, config, ... }:
let
    cfg = config.embedded.tiva;
in
{

    options.embedded.tiva = {
        enable = lib.mkEnableOption "Tivaware support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            gcc-arm-embedded-9 # toolchain
            (pkgs.callPackage ../../../../pkgs/lm4flash.nix { }) # flashing tool
        ];
    };
}
