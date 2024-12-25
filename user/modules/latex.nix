{ pkgs, lib, config, ... }:
let
    cfg = config.latex;
in
{

    options.latex = {
        enable = lib.mkEnableOption "Latex support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            texlive.combined.scheme-full  # latex with everything
            blatex                        # my latex document framework
        ];
    };
}
