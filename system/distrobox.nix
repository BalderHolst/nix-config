{ pkgs, lib, config, ... }:
let
    cfg = config.distrobox;
in
{
    options.distrobox = {
        enable = lib.mkEnableOption "Distrobox";
    };

    config = lib.mkIf cfg.enable {
        virtualisation.podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true; 
        };

        environment.systemPackages = with pkgs; [
            distrobox
        ];
    };
}
