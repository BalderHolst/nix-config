# Edit this configuration file to define what should be installed on

# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "goldfish"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.gnome.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "dk";
    xkbVariant = "";
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."balder" = {
    isNormalUser = true;
    description = "Balder";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [ ];
  };

  # Enable automatic login for the user.
  # services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "balder";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # ====== Desktop ======
    hyprland # compositor and window manager
    hyprpaper # wallpaper
    waybar # bar
    wofi # app launcher
    pavucontrol # audio control GUI
    brightnessctl # control backlight
    dunst # notifications
    home-manager # nix home manager
    themechanger

    # ====== VMs ======
    virt-manager
    libvirt
    qemu

    # ====== CLI ======
    htop # process viewer
    wget # cli file downloader
    tree # overview of file structures
    bat # better cat
    exa # pretty ls

    # ====== General ======
    brave # main browser
    firefox # alternative browser
    syncthing # syncronize files with my other computers
    libreoffice # office suite to open those awful microsoft files
    zathura # pdf-viewer
    sxiv # image viewer
    mpv # audio player
    vlc # video player
    gnome.nautilus # gui file explorer
    ranger # terminal file explorer
    audacity # audio editor
    gnome.eog # svg viewer

    # ====== Development ======
    git # you know why
    zsh # better bash
    fish # shell for the 90s!
    ripgrep # awesome grepping tool
    neovim # best text editor
    kitty # terminal emulator
    gnat13 # GNU compilers 
    python311 # Python interpreter

    rustc # the rust compiler
    cargo # rust build toolchain
    rustfmt # rust formatter
    rust-analyzer # lsp for rust
    clippy # rust linter

    # ====== Study ======
    obsidian # note taking

  ];

  # Enable virtual machines, see: https://nixos.wiki/wiki/Virt-manager
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    nerdfonts
    font-awesome
  ];

  # services.locate = {
  #   enable = true;
  #   locate = pkgs.mlocate;
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
      xdg-desktop-portal-hyprland
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
