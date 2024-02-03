# Edit this configuration file to define what should be installed on

# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, username, pkgs, pkgs-unstable, rustPlatform, ... }:

let
    hostname = "goldfish";
in 
{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
            ../../system/nas_sync.nix
        ];

    nas.network-ssid = "TP-Link_96CC";
    nas.rclone-device = "NAS";
    nas.sync-locations = 
    let
        home = "/home/${username}";
    in
    [
        { local = "${home}/Documents/uni/lectures"; remote = "uni";                 }
        { local = "${home}/3d-print";               remote = "3d-print";            }
        { local = "${home}/Pictures/wallpapers";    remote = "general/wallpapers";  }
        { local = "${home}/Documents/opskrifter";   remote = "general/opskrifter";  }
        { local = "${home}/Documents/papirer";      remote = "private/papirer";     }
        { local = "${home}/Documents/job";          remote = "private/job";         }
    ];

    # Enable flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Enable NUR
    nixpkgs.config.packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball {
                url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
                sha256 = "";
                }) {
            inherit pkgs;
        };
    };

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Make sure i can mount windows drives
    boot.supportedFilesystems = [ "ntfs" ];

    networking.hostName = hostname; # Define your hostname.
    # networking.wireless.enable = true;    # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Bluetooth
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;

    # Audo mount USB
    services.devmon.enable = true;

    # Cloud drives
    fileSystems = (
        let
        opts = [ "x-systemd.automount" "noauto" "x-systemd.after=network-online" ];
        in
    {
        "/media/uni-remote" = {
            device = "192.168.0.200:/uni";
            fsType = "nfs";
            options = opts;
            };

        "/media/3d-print" = {
            device = "192.168.0.200:/3d-print";
            fsType = "nfs";
            options = opts;
        };

        "/media/music" = {
            device = "192.168.0.200:/music";
            fsType = "nfs";
            options = opts;
        };

        "/media/private" = {
            device = "192.168.0.200:/private";
            fsType = "nfs";
            options = opts;
        };

        "/media/general" = {
            device = "192.168.0.200:/general";
            fsType = "nfs";
            options = opts;
        };
    });

    # Syncthing
    services.syncthing = {
        enable = true;
        user = username;
        dataDir = "/home/${username}/Documents";
        configDir = "/home/${username}/Documents/.config/syncthing";
        overrideDevices = true;         # overrides any devices added or deleted through the WebUI
        overrideFolders = true;         # overrides any folders added or deleted through the WebUI
        devices = {
            "waterbear"     = { id = "NRP4KUT-OSWI7C6-3JMN7EL-JFWQ2AS-XRGM6OK-6WVSZ3G-3Q2CHBJ-UYCKQAE"; };
        };
        folders = {
            "uni" = {
                path = "/home/${username}/Documents/uni";
                devices = [ "waterbear" ];
            };
            "job" = {
                path = "/home/${username}/Documents/job";
                devices = [ "waterbear" ];
            };
            "pictures" = {
                path = "/home/${username}/Pictures";
                devices = [ "waterbear" ];
            };
            "isos" = {
                path = "/home/${username}/isos";
                devices = [ "waterbear" ];
            };
        };
    };

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

    # Enable the X11 windowing system.
    services.xserver = {
        enable = true;
        displayManager.sddm = {
            enable = true;
            theme = "sugar-dark";
        };
        layout = "dk";
        xkbVariant = "";
    };

    # Kill X11 server after 5 seconds on shutdown
    systemd.extraConfig = ''
        DefaultTimeoutStopSec=5s
    '';

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
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."${username}" = {
        isNormalUser = true;
        description = "Administrator of this computer.";
        extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" ];
        packages = with pkgs; [ ];
    };

    # Enable docker
    # virtualisation.docker = {
        # enable = true;
        # storageDriver = "btrfd";
        # rootless = {
            # enable = true;
            # setSocketVariable = true;
        # };
    # };

    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [

        # ====== Desktop ======
        hyprpaper # wallpaper
        waybar # bar
        rofi-wayland # app launcher
        pavucontrol # audio control GUI
        dunst # notifications
        libnotify # send notifications
        home-manager # nix home manager
        pkgs.libsForQt5.qt5.qtgraphicaleffects # library used by a lot of sddm themes
        (callPackage ../../pkgs/sddm/themes.nix { }).sugar-dark # sddm theme

        # ====== VMs ======
        virt-manager
        libvirt
        qemu

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


    # Locate
    services.locate = {
        enable = true;
        locate = pkgs.mlocate;
        interval = "hourly";
        localuser = null;
    };

    # Games
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

    # Enable virtual machines, see: https://nixos.wiki/wiki/Virt-manager
    virtualisation.libvirtd.enable = true;
    programs.dconf.enable = true;

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

    # services.locate = {
    #     enable = true;
    #     locate = pkgs.mlocate;
    # };

    # Enable hyprland
    programs.hyprland = {
        enable = true;
        nvidiaPatches = true;
        xwayland.enable = true;
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
        # WLR_NO_HARDWARE_CURSORS = "1";
        MOZ_ENABLE_WAYLAND = "1"; # Hint firefox to use wayland
        NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
    };

    hardware = {
        opengl.enable = true; # enable opengl
        nvidia.modesetting.enable = true;
    };

    services.dbus.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
            xdg-desktop-portal-wlr
            xdg-desktop-portal-gtk
        ];
    };

    # Be a tor relay: https://nixos.wiki/wiki/Tor
    # services.tor = {
    #     enable = true;
    #     openFirewall = true;
    #     relay = {
    #         enable = true;
    #         role = "relay";
    #     };
    #     settings = {
    #         # ContactInfo = "toradmin@example.org";
    #         Nickname = "toradmin";
    #         ORPort = 9001;
    #         ControlPort = 9051;
    #         BandWidthRate = "1 MBytes";
    #     };
    # };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #     enable = true;
    #     enableSSHSupport = true; };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    # services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "23.05"; # Did you read the comment?
}
