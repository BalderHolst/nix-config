{
    description = "Balder's NixOs Configuration Flake";


    outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager, ... }:
    let
    system = "x86_64-linux";
    username = "balder";
    email = "balderwh@gmail.com";
    configDir = "/home/${username}/.nix-config";

    profiles = [
        "goldfish"
        "dolphin"
    ];

    overlay = (final: prev: {
        bmark = prev.callPackage pkgs/bmark.nix { };
        blatex = prev.callPackage pkgs/blatex.nix { };
        pyprland = prev.callPackage pkgs/pyprland.nix { };
        matlab-icon = prev.callPackage pkgs/matlab-icon.nix { inherit configDir; };
        mathematica-icon = prev.callPackage pkgs/mathematica-icon.nix { mathematicaPath = "${configDir}/impure/mathematica/result/bin/mathematica"; };
        waybar = prev.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
    });

    # configure pkgs
    pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [ overlay ];
    };

    pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [ overlay ];
    };

    # configure lib
    lib = nixpkgs-stable.lib;

    in
    {
        overlays.default = overlay;

        # Generate system configurations
        nixosConfigurations = builtins.listToAttrs (
            builtins.map (profile: {
                name = profile;
                value = lib.nixosSystem {
                    inherit system;
                    pkgs = pkgs-stable;
                    modules = [ ./profiles/${profile}/configuration.nix ];
                    specialArgs = {
                        hostname = profile;
                        inherit username;
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
                    inherit username;
                    inherit email;
                    inherit configDir;
                };
            };
            }) profiles
        );

    };

    inputs = rec {

        nixpkgs-stable.url = "github:NixOS/nixpkgs/23.11";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };

        hyprland.url = "github:hyprwm/Hyprland";

        hyprgrass = {
            url = "github:horriblename/hyprgrass";
            inputs.hyprland.follows = "hyprland"; # IMPORTANT
        };
    };
}
