{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../system/niri.nix
        ../../system/steam.nix
        ../../system/general.nix
    ];

    networking.hostName = "dolphin"; # Define your hostname.

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


    # Enable the Cinnamon Desktop Environment.
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

    # https://nixos.org/nixos/options.html
    system.stateVersion = "26.05";
}
