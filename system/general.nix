{ pkgs, username, ... }:
{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."${username}" = {
        isNormalUser = true;
        description = "Administrator of this computer.";
        extraGroups = [
            "networkmanager"
            "wheel"
            "libvirtd"
            "docker"
            "dialout"
        ];
        packages = with pkgs; [ ];
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Audo mount USB
    services.devmon.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Copenhagen";

    # Select internationalisation properties.
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

    # Configure console keymap
    console.keyMap = "dk-latin1";

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        socketActivation = true;
    };

    # Locate
    services.locate = {
        enable = true;
        locate = pkgs.mlocate;
        interval = "hourly";
        localuser = null;
    };

    fonts.fontDir.enable = true;
    fonts.fonts = with pkgs; [
        nerdfonts
        font-awesome
    ];

    services.dbus.packages = [ pkgs.gcr ];
    services.pcscd.enable = true;
    programs.gnupg.agent = {
        enable = true;
        pinentryFlavor = "qt";
        enableSSHSupport = true;
    };

    environment.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1"; # Hint firefox to use wayland
        NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    };

    hardware = {
        opengl.enable = true; # enable opengl
        nvidia.modesetting.enable = true;
    };

    services.dbus.enable = true;

    environment.systemPackages = with pkgs; [

        # ====== Desktop ======
        dunst # notifications
        libnotify # send notifications
        home-manager # nix home manager
        pkgs.libsForQt5.qt5.qtgraphicaleffects # library used by a lot of sddm themes

        # ====== CLI ======
        htop # process viewer
        wget # cli file downloader
        tree # overview of file structures
        bat # better cat
        file # show file info
        zip # zip your files
        unzip # unzip your files
        git # you know why
        neovim # best text editor

        pinentry-qt
        
    ];
}
