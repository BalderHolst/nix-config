{
  description = "Balder's System Flake";

  outputs = inputs@{ self, nixpkgs-stable, nixpkgs-unstable, home-manager, ... }:
  let
    system = "x86_64-linux";
    username = "balder";
    email = "balderwh@gmail.com";
    configDir = "/home/${username}/.nix-config";

    profile = import ./profile.nix;

    # configure pkgs
    pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [
            (final: prev: {
                bmark = prev.callPackage pkgs/bmark.nix { };
                blatex = prev.callPackage pkgs/blatex.nix { };
                pyprland = prev.callPackage pkgs/pyprland.nix { };
                matlab-icon = prev.callPackage pkgs/matlab-icon.nix { inherit configDir; };
                mathematica-icon = prev.callPackage pkgs/mathematica-icon.nix { mathematicaPath = "${configDir}/impure/mathematica/result/bin/mathematica"; };
            })
        ];
    };

    pkgs-stable = import nixpkgs-stable {
        inherit system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [
            (final: prev: {
                waybar = prev.waybar.overrideAttrs (oldAttrs: {
                    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                });
            })
        ];
    };

    # configure lib
    lib = nixpkgs-stable.lib;

  in {

    homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgs-unstable;
            modules = [ (./. + "/profiles"+("/"+profile)+"/home.nix") ]; # load home.nix from selected PROFILE
            extraSpecialArgs = {
                inherit inputs;
                inherit username;
                inherit profile;
                inherit email;
                inherit configDir;
            };
        };
    };
    nixosConfigurations = {
        "system" = lib.nixosSystem {
            inherit system;
            pkgs = pkgs-stable;
            modules = [ (./. + "/profiles"+("/"+profile)+"/configuration.nix") ]; # load configuration.nix from selected PROFILE
            specialArgs = {
                inherit username;
                inherit pkgs-unstable;
            };
        };
        };
    };

    inputs = rec {

        nixpkgs-stable.url = "github:NixOS/nixpkgs/23.05";
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
