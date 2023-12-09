{pkgs ? import <nixpkgs> { }}:

# Wally is a tool uploading firmware to my mechanical keyboard

let
  inherit (pkgs) stdenv;
  libusb = pkgs.libusb1;
  gtk3 = pkgs.gtk3;
  webkit = pkgs.webkitgtk;
  wally = builtins.fetchurl {
      url = "https://configure.ergodox-ez.com/wally/linux";
      sha256 = "sha256:1pnvmxwnm0ln23mzwfl0w2inz4qzlacsrwpp91g9fi6m5x69f353";
  };
in 
stdenv.mkDerivation rec {
    name = "wally";

    src = ./.;

    buildPhase = ''
    '';

    installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/etc
    mkdir -p $out/share

    ln -s ${libusb}/lib/* $out/lib
    ln -s ${libusb}/etc/* $out/etc
    ln -s ${libusb}/share/* $out/share
    ln -s ${gtk3}/lib/* $out/lib
    ln -s ${gtk3}/etc/* $out/etc
    ln -s ${gtk3}/share/* $out/share
    #ln -s ${webkit}/lib/* $out/lib
    #ln -s ${webkit}/etc/* $out/etc
    #ln -s ${webkit}/share/* $out/share

    mkdir -p $out/bin
    cp ${wally} $out/bin/wally
    chmod +x $out/bin/wally
    '';

}
