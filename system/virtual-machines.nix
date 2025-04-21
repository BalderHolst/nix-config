{ pkgs, lib, config, ... }:
let
    cfg = config.virtual-machines;
in
{
    options.virtual-machines = {
        enable = lib.mkEnableOption "Virtual machines with QEMU and libvirt";
    };

    config = lib.mkIf cfg.enable {
        virtualisation.libvirtd.enable = true;
        environment.systemPackages = with pkgs; [
            virt-manager
            libvirt
            qemu
        ];
    };
}
