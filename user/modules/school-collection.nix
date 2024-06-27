{ pkgs, ... }:
{
    home.packages = with pkgs; [
        matlab-icon # Desktop icon for matlab
        mathematica-icon # Desktop icon for mathematica
    ];
}
