{ pkgs, ... }:
{
    environment.systemPackages = [
        (pkgs.callPackage ../pkgs/sddm/themes.nix { }).sugar-dark
    ];

    # Enable the X11 windowing system.
    services = {
        displayManager.sddm.wayland.enable = true;
        displayManager.sddm = {
            enable = true;
            theme = "sugar-dark";
        };
        xserver = {
            xkb = {
                variant = "";
                layout = "dk";
            };
        };
    };

    # Kill X11 server after 5 seconds on shutdown
    systemd.extraConfig = ''
        DefaultTimeoutStopSec=5s
    '';

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    programs.dconf.enable = true;

}
