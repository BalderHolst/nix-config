{ pkgs, lib, config, ... }:
let
    cfg = config.lang.python;
in
{

    options.lang.python = {
        enable = lib.mkEnableOption "Python language support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            python311                 # Python interpreter
            python311Packages.bpython # Fancy Python REPL
        ];
    };
}
