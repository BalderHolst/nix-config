{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) stdenv;

  name = "rclone-1.65.2";
  src = pkgs.fetchFromGitHub {
      owner = "rclone";
      repo = "rclone";
      rev = "ffcaa6cd927929a871609a8d6ce0004324feb8d0";
      sha256 = "sha256-P7VJ6pauZ7J8LvyYNi7ANsKrYOcmInZCfRO+X+K6LzI=";
  };

in
pkgs.buildGoModule {
    inherit src name;
    vendorHash = "sha256-budC8psvTtfVi3kYOaJ+dy/9H11ekJVkXMmeV9RhXVU=";
    doCheck = false;
}

