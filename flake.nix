{
  description = "Balder's System Flake";

  outputs = inputs@{ self, nixpkgs-stable, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    username = "balder";
    email = "balderwh@gmail.com";
    configDir = "/home/${username}/.nix-config";

    profile = import ./profile.nix;

    # configure pkgs
    home-pkgs = import nixpkgs {
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
                matlab-icon = prev.callPackage pkgs/matlab-icon.nix { userHome = "/home/${username}"; };
                mathematica-icon = prev.callPackage pkgs/mathematica-icon.nix { mathematicaPath = "${configDir}/impure/mathematica/result/bin/mathematica"; };
            })
        ];
    };

    system-pkgs = import nixpkgs-stable {
        inherit system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
    };

    # configure lib
    lib = nixpkgs-stable.lib;

  in {

    homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
            pkgs = home-pkgs;
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
            pkgs = system-pkgs;
            modules = [ (./. + "/profiles"+("/"+profile)+"/configuration.nix") ]; # load configuration.nix from selected PROFILE
            specialArgs = { inherit username; };
        };
        };
    };

    inputs = rec {

        nixpkgs-stable.url = "github:NixOS/nixpkgs/23.05";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        firefox-addons = {
            url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland.url = "github:hyprwm/Hyprland";
        hyprgrass = {
            url = "github:horriblename/hyprgrass";
            inputs.hyprland.follows = "hyprland"; # IMPORTANT
        };
    };
}
