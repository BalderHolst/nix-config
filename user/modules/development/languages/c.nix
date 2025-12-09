{ pkgs, lib, config, ... }:
let
    cfg = config.lang.c;
in
{

    options.lang.c = {
        enable = lib.mkEnableOption "C language support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            cmake     # CMake
            gnat      # GNU compilers 
            man-pages # man pages for development
        ];
    };
}
