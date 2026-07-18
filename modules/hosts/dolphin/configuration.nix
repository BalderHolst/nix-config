{ self, inputs, ... }: {

    flake.nixosModules.dolphinConfiguration = { pkgs, lib, ... }: {

        imports = [
            self.nixosModules.dolphinHardware
            self.nixosModules.niri
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

    };

}
