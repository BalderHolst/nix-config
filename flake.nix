{
  description = "Balder's System Flake";

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    username = "balder";
    email = "balderwh@gmail.com";
    configDir = "/home/${username}/.nix-config";

    profile = import ./profile.nix;

    # configure pkgs
    pkgs = import nixpkgs {
        inherit system;
        config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
        };
        overlays = [
            (final: prev: {
                bmark = pkgs.callPackage pkgs/bmark.nix { };
                blatex = pkgs.callPackage pkgs/blatex.nix { };
                pyprland = pkgs.callPackage pkgs/pyprland.nix { };
                matlab-icon = pkgs.callPackage pkgs/matlab-icon.nix { userHome = "/home/${username}"; };
                mathematica-icon = pkgs.callPackage pkgs/mathematica-icon.nix { mathematicaPath = "${configDir}/impure/mathematica/result/bin/mathematica"; };
            })
        ];
    };

    # configure lib
    lib = nixpkgs.lib;

  in {

    homeConfigurations = {
        "${username}" = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
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
            modules = [ (./. + "/profiles"+("/"+profile)+"/configuration.nix") ]; # load configuration.nix from selected PROFILE
            specialArgs = { inherit username; };
        };
        };
    };

    inputs = rec {

        nixpkgs.url = "github:NixOS/nixpkgs/23.11";

        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
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
