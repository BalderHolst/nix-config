{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation rec {
    name = "avr-libc";
    src = pkgs.fetchFromGitHub {
        owner = "avrdudes";
        repo = "avr-libc";
        rev = "45b68260bdaa6ea336106502836d6b1a49dabc6b";
        sha256 = "sha256-V0MlFn7lGUOal4acYuBNvK+9H4BEWUVKP6LTBS5ikjo=";
    };

    buildPhase = ""; # no build phase

    installPhase = ''
        mkdir -v -p "$out"
        cp -vr * "$out"
    '';
}

