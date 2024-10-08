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
            cmakeMinimal # cmake
            gnat14 # GNU compilers 
            (pkgs.writeShellScriptBin "gcc800" ''
                gcc -Wall -Werror -ansi -pedantic -std=c99 $@
            '')
        ];
    };
}
