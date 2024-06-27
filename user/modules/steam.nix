{ lib, config, pkgs, ... }:
{

    config.home.packages = with pkgs; [
        protonup-qt # play windows games
        mangohud # game overlay
    ];

}

