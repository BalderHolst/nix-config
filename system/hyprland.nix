{ pkgs, ... }:
{
    # Enable hyprland
    programs.hyprland = {
        enable = true;
        enableNvidiaPatches = true;
        xwayland.enable = true;
    };

    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];
    };

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
    };
}
