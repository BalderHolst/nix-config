{ self, inputs, ...}: {

    flake.nixosModules.dolphinHardware = { config, lib, pkgs, modulesPath, ... }:
    {
        imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

        boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-intel" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" =
        { device = "/dev/disk/by-uuid/bc91f7ea-8b42-42cb-a35e-40c7957bedae";
            fsType = "ext4";
        };

        fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/BEA9-3D96";
            fsType = "vfat";
            options = [ "fmask=0077" "dmask=0077" ];
        };

        fileSystems."/home" =
        { device = "/dev/disk/by-uuid/9bbb90eb-b963-4c56-b3fb-349be5d49dbd";
            fsType = "ext4";
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
