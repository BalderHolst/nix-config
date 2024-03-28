{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "clangd";
  src = pkgs.rocmPackages.llvm.clang-tools-extra;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out
    '';
}
