{ pkgs, lib, config, ... }:
let
    cfg = config.lang.python;
in
{

    options.lang.python = {
        enable = lib.mkEnableOption "Python language support";
        notebooks = lib.mkEnableOption "Jupyter notebooks";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            (python3.withPackages (python-pkgs: with python-pkgs; [
                  # select Python packages here
                  pandas
                  requests
                  numpy
                  matplotlib
                  bpython
            ] ++ (if cfg.notebooks then [ jupyter ] else [])
            ))
        ];
    };
}
