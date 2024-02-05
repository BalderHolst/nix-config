{ pkgs ? import <nixpkgs> { } }:

let
    name = "lm2tools";

    inherit (pkgs) stdenv;

    # The path to the npm project
    src = pkgs.fetchFromGitHub {
            owner = "utzig";
            repo = "lm4tools";
            rev = "61a7d17b85e9b4b040fdaf84e02599d186f8b585";
            sha256 = "sha256-rT19C4262/k14AJc/rNcXObnpFUuPVD//3ldPXaid70=";
    };

    libusb = pkgs.fetchFromGitHub {
            owner = "libusb";
            repo = "libusb";
            rev = "d52e355daa09f17ce64819122cb067b8a2ee0d4b";
            sha256 = "sha256-OtzYxWwiba0jRK9X+4deWWDDTeZWlysEt0qMyGUarDo=";
    } + "/libusb";
in
stdenv.mkDerivation rec {
    inherit src name;

    buildInputs = [
        pkgs.libusb1
        pkgs.gccgo13
        ];

    buildPhase = ''
        echo "${pkgs.libusb1}"
        mkdir build
        cc -Wall -I${libusb} lm4flash/lm4flash.c ${pkgs.libusb1}/lib/libusb-1.0.so -o build/lm4flash
    '';

    installPhase = ''
        mkdir -v -p "$out/bin"
        cp -v build/* "$out/bin"
    '';
}

