{ pkgs ? import <nixpkgs> {} }:

rec {
    script-pkgs = rec {
        niripy = pkgs.python3Packages.callPackage ../../../../pkgs/niripy.nix {};
        python = pkgs.python3.withPackages (ps: [ niripy ]);

        python-bin = pkgs.lib.getExe python;
    };

    create-empty-first-workspace = pkgs.writeShellScript "create-empty-first-workspace" ''
        ${script-pkgs.python-bin} ${./create-empty-first-workspace.py}
    '';
}
