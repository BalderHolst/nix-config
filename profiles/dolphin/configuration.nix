{ pkgs, ... }: {
    imports = [
        ./hardware-configuration.nix
        ../../system/niri.nix
        ../../system/steam.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "dolphin"; # Define your hostname.

        networking.networkmanager.enable = true;

    hardware.graphics.enable = true;


    nix.settings.experimental-features = ["nix-command" "flakes"];

    time.timeZone = "Europe/Copenhagen";

    i18n.defaultLocale = "en_DK.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "da_DK.UTF-8";
        LC_IDENTIFICATION = "da_DK.UTF-8";
        LC_MEASUREMENT = "da_DK.UTF-8";
        LC_MONETARY = "da_DK.UTF-8";
        LC_NAME = "da_DK.UTF-8";
        LC_NUMERIC = "da_DK.UTF-8";
        LC_PAPER = "da_DK.UTF-8";
        LC_TELEPHONE = "da_DK.UTF-8";
        LC_TIME = "da_DK.UTF-8";
    };


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


    # Enable comma
    programs.nix-index-database.comma.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the Cinnamon Desktop Environment.
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "dk";
        variant = "";
    };

    # Configure console keymap
    console.keyMap = "dk-latin1";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."balder" = {
        isNormalUser = true;
        description = "Balder";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
        ];
    };

    # Install firefox.
    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
        git
        neovim
        ripgrep
    ];

    # https://nixos.org/nixos/options.html
    system.stateVersion = "26.05";
}
