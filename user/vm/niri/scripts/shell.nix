{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    (import ./default.nix {}).script-pkgs.python
  ];
}
