# Edit this configuration file to define what should be installed on

# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ hostname, user, config, pkgs, ... }:

{
    imports =
        [
            ./hardware-configuration.nix
            ../../system/nas-sync.nix
            ../../system/general.nix
            ../../system/hyprland.nix
            ../../system/sddm.nix
            ../../system/steam.nix
            ../../system/docker.nix
            ../../system/act.nix
        ];

    networking.hostName = hostname; # Define your hostname.
    system.stateVersion = "23.05"; # Did you read the comment?

    services.xserver.enable = true;

    programs.nix-ld.enable = true;

    # Sync with NAS
    nas.always-sync = true;
    nas.rclone-device = "NAS";
    nas.interval = 5*60;
    nas.sync-locations = 
    let
        home = "/home/${user.username}";
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

    # Cloud drives
    fileSystems = 
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
    };

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        LIBVA_DRIVER_NAME = "nvidia";
        XDG_SESSION_TYPE = "wayland";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
}
