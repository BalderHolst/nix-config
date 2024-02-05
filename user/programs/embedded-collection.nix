{ pkgs, ... }:
{
    home.packages = with pkgs; [
        gcc-arm-embedded-9
        (pkgs.callPackage ../../pkgs/lm4flash.nix { })
    ];
}
