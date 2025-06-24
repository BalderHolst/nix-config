{
    description = "Balder's NixOs Configuration Flake";

    outputs = inputs@{ nixpkgs-stable, nixpkgs-unstable, home-manager, rust-overlay, ... }:
    let

    user = import ./user.nix;
    configDir = "/home/${user.username}/.nix-config";

    profiles = [
        "goldfish"
        "dolphin"
    ];

    overlay = (final: prev: {
        bmark = prev.callPackage pkgs/bmark.nix { };
        blatex = prev.callPackage pkgs/blatex.nix { };
        pyprland = prev.callPackage pkgs/pyprland.nix { };
        mathematica-icon = prev.callPackage pkgs/mathematica-icon.nix { mathematicaPath = "${configDir}/impure/mathematica/result/bin/mathematica"; };
        waybar = prev.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
    });

    pkgs-stable = import nixpkgs-stable {
        inherit (user) system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [ overlay ];
    };

    # Overlay to fix unstable packages
    unstable-overlay = (final: prev: {
        firefox = pkgs-stable.firefox;
        pdfpc = pkgs-stable.pdfpc;
        font-manager = pkgs-stable.font-manager;
        stable = pkgs-stable;
    });

    # configure pkgs
    pkgs-unstable = import nixpkgs-unstable {
        inherit (user) system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [
            overlay
            rust-overlay.overlays.default
            unstable-overlay
            inputs.nix-matlab.overlay
        ];
    };

    # configure lib
    lib = nixpkgs-stable.lib;

    in
    {
        overlays.default = overlay;

        packages."${user.system}".install = pkgs-stable.stdenv.mkDerivation rec {
            name = "install-config";
            src = ./.;
            buildPhase = "";
            installPhase = ''
                mkdir -p $out/bin
                ln -s $src/install.sh $out/bin/${name}
            '';
        };


        # Generate system configurations
        nixosConfigurations = builtins.listToAttrs (
            builtins.map (profile: {
                name = profile;
                value = lib.nixosSystem {
                    pkgs = pkgs-stable;
                    modules = [
                        ./profiles/${profile}/configuration.nix
                    ];
                    specialArgs = {
                        hostname = profile;
                        inherit user;
                        inherit pkgs-unstable;
                        inherit configDir;
                    };
                };
            }) profiles
        );

        # Generate home-manager configurations
        homeConfigurations = builtins.listToAttrs (
        builtins.map (profile: {
            name = profile;
            value = home-manager.lib.homeManagerConfiguration {
                pkgs = pkgs-unstable;
                modules = [ ./profiles/${profile}/home.nix ];
                extraSpecialArgs = {
                    hostname = profile;
                    inherit inputs;
                    inherit user;
                    inherit configDir;
                };
            };
            }) profiles
        );

    };

    inputs = {

        nixpkgs-stable.url = "github:NixOS/nixpkgs/25.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        hyprland = {
            url = "github:hyprwm/Hyprland";
            inputs.nixpkgs.follows = "nixpkgs-stable";
        };

        hyprgrass = {
            url = "github:horriblename/hyprgrass";
            inputs.hyprland.follows = "hyprland"; # IMPORTANT
        };

        nix-matlab = {
            inputs.nixpkgs.follows = "nixpkgs-stable";
            url = "gitlab:doronbehar/nix-matlab";
        };

        rust-overlay.url = "github:oxalica/rust-overlay";
    };
}
