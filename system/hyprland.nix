{ pkgs, ... }:
{
    # Enable hyprland
    programs.hyprland = {
        enable = true;
        nvidiaPatches = true;
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


    # Enable experimental waybar features, to capture use the `wlr` module.
    nixpkgs.overlays = [
        (self: super: {
            waybar = super.waybar.overrideAttrs (oldAttrs: {
                mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            });
        })
    ];

    environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
    };
}
