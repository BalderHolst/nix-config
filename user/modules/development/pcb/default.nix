{ pkgs, lib, config, ... }:
let
    cfg = config.pcb;
in
{

    options.pcb = {
        enable = lib.mkEnableOption "Enable PCB tools";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            stable.kicad # design PCBs and draw circuits
        ];
    };
}
