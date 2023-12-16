{ pkgs, ... }:
{
    home.packages = with pkgs; [
        (callPackage ../pkgs/matlab-icon.nix { userHome = "/home/balder"; }) # Desktop icon for matlab
        (callPackage ../pkgs/mathematica-icon.nix { userHome = "/home/balder"; }) # Desktop icon for mathematica
        obsidian # note taking
    ];
}
