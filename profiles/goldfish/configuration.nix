# Edit this configuration file to define what should be installed on

# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, username, pkgs, pkgs-unstable, rustPlatform, ... }:

let
    hostname = "goldfish";
in 
{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ../../system/nas-sync.nix
            ../../system/general.nix
            ../../system/hyprland.nix
            ../../system/sddm.nix
            ../../system/steam.nix
            ../../system/act.nix
        ];

    networking.hostName = hostname;
    nixpkgs.config.allowUnfree = true;

    # Sync with NAS
    nas.network-ssid = "TP-Link_96CC";
    nas.rclone-device = "NAS";
    nas.interval = 60*2;
    nas.sync-locations = 
    let
        home = "/home/${username}";
    in
    [
        { local = "${home}/3d-print";               remote = "3d-print";            }
        { local = "${home}/Pictures";               remote = "general/pictures";    }
        { local = "${home}/Documents/opskrifter";   remote = "general/opskrifter";  }
        { local = "${home}/Documents/papirer";      remote = "private/papirer";     }
        { local = "${home}/Documents/job";          remote = "private/job";         }
        { local = "${home}/Documents/uni/lectures"; remote = "uni";                 }
    ];
    nas.remote-backup-dir = "backups/manual";
    nas.backup-exclude = [
        "software"
        "isos"
        "build"
        ".cache"
        ".arduino15"
        ".matlab"
        ".cargo"
        "target"
        "Steam"
    ];

    # Cloud drives
    fileSystems = (
        let
        opts = [ "x-systemd.automount" "noauto" "x-systemd.after=network-online" ];
        nas = "192.168.0.200";
        in
    {
        "/media/uni-remote" = {
            device = "${nas}:/uni";
            fsType = "nfs";
            options = opts;
            };

        "/media/3d-print" = {
            device = "${nas}:/3d-print";
            fsType = "nfs";
            options = opts;
        };

        "/media/music" = {
            device = "${nas}:/music";
            fsType = "nfs";
            options = opts;
        };

        "/media/private" = {
            device = "${nas}:/private";
            fsType = "nfs";
            options = opts;
        };

        "/media/general" = {
            device = "${nas}:/general";
            fsType = "nfs";
            options = opts;
        };
    });

    system.stateVersion = "23.05";
}
