{ pkgs, ... }:
{
    home.packages = with pkgs; [
        mathematica-icon # Desktop icon for mathematica
    ];
}
