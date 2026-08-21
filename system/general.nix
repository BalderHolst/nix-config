{ pkgs, user, ... }:
{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."${user.username}" = {
        isNormalUser = true;
        description = "Administrator of this computer.";
        extraGroups = [
            "networkmanager"
            "wheel"
            "libvirtd"
            "docker"
            "dialout"
        ];
        packages = [ ];
    };

    # Enable comma
    programs.nix-index-database.comma.enable = true;

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Enable networking
    networking.networkmanager.enable = true;

    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "dk";
        variant = "";
    };

    # Auto mount USB
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
    console = {
        enable = true;
        # Override the console keymaps to unbind Alt+Left (Decr_Console) and Alt+Right (Incr_Console)
        keyMap = pkgs.runCommand "dk-latin1-no-tty-switch.kmap" {} ''

            # Set the keyboard to "dk-lation1"
            gzip -dc ${pkgs.kbd}/share/keymaps/i386/qwerty/dk-latin1.map.gz > $out

            # Append the keycode unbinds
            cat <<EOF >> $out
            alt keycode 105 = VoidSymbol
            alt keycode 106 = VoidSymbol
            EOF
        '';
    };

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
        socketActivation = true;
    };

    # Locate
    # services.locate = {
    #     enable = true;
    #     package = pkgs.mlocate;
    #     interval = "hourly";
    # };

    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
        noto-fonts
        font-awesome
        lmodern
    ];

    services.pcscd.enable = true;
    programs.gnupg.agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-qt;
        enableSSHSupport = true;
    };

    environment.sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1; # Hint firefox to use wayland
        NIXOS_OZONE_WL = 1;     # Hint electron apps to use wayland
    };

    hardware = {
        graphics.enable = true; # enable opengl
        nvidia.modesetting.enable = true;
    };

    services.dbus.enable = true;
    # services.dbus.packages = [ pkgs.gcr ];

    environment.systemPackages = with pkgs; [

        # ====== Desktop ======
        home-manager # nix home manager
        pkgs.libsForQt5.qt5.qtgraphicaleffects # library used by a lot of sddm themes

        # ====== CLI ======
        htop   # process viewer
        btop   # better process viewer
        wget   # cli file downloader
        tree   # overview of file structures
        bat    # better cat
        file   # show file info
        zip    # zip your files
        unzip  # unzip your files
        git    # you know why
        neovim # best text editor

    ];

}
