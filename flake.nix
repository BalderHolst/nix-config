{
  description = "Balder's System Flake";

  outputs = inputs@{ self, nixpkgs, home-manager, ... }:
  let
    # ---- SYSTEM SETTINGS ---- #
    system = "x86_64-linux";
    hostname = "dolphin"; # hostname
    profile = "dolphin"; # select a profile defined from my profiles directory
    timezone = "Denmark/Copenhagen"; # select timezone
    locale = "en_DK.UTF-8"; # select locale

    # ----- USER SETTINGS ----- #
    username = "balder"; # username
    name = "Balder"; # name/identifier
    email = "balderwh@gmail.com"; # email (used for certain configurations)
    configDir = "/home/${username}/.nix-config"; # absolute path of the local repo
    theme = "firewatch"; # selcted theme from my themes directory (./themes/)
    ui_scale = 1.5;


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
                mathematica-icon = pkgs.callPackage pkgs/mathematica-icon.nix { userHome = "/home/${username}"; };
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
            inherit name;
            inherit hostname;
            inherit profile;
            inherit email;
            inherit theme;
            inherit ui_scale;
          };
      };
    };
    nixosConfigurations = {
      "system" = lib.nixosSystem {
        inherit system;
        modules = [ (./. + "/profiles"+("/"+profile)+"/configuration.nix") ]; # load configuration.nix from selected PROFILE
        specialArgs = {
          # pass config variables from above
          inherit username;
          inherit name;
          inherit hostname;
          inherit timezone;
          inherit locale;
          inherit theme;
        };
      };
    };
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
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
