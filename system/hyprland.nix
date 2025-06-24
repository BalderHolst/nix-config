{ pkgs, ... }:
{
    # Enable hyprland
    programs.hyprland = {
        enable = true;
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
}
