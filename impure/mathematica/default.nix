let
    pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz") { };
in
pkgs.mathematica.override {
  source = pkgs.requireFile {
    name = "Mathematica_13.1.0_BNDL_LINUX.sh";
    # Get this hash via a command similar to this:
    # nix-store --query --hash \
    # $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica_XX.X.X_BNDL_LINUX.sh')
    sha256 = "sha256:016638jwm9ipckh4pk3clagiv1a38ga96cg40sc90pwxqhkbp3rk";
    message = ''
      Your override for Mathematica includes a different src for the installer,
      and it is missing.
    '';
    hashMode = "recursive";
  };
}
