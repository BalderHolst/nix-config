{ pkgs, ... }: {

    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
        kdePackages.breeze # Cursor
        xwayland-satellite
        kitty
        firefox
        noctalia-shell
    ];

}
