{ pkgs ? import <nixpkgs> { }, name ? "clangd", include_paths ? [] }:

let
    inherit (pkgs) lib stdenv;

    src = pkgs.clang-tools;

    # Create a directory with a 'compile_flags.txt' file to be passed into clangd.
    compile_flags = stdenv.mkDerivation {
        name = "compile_flags";
        src = ./.;

        buildPhase = ""; # No build phase needed.

        installPhase = ''
            mkdir -p $out
            cp ${
                # Generate a 'compile_flags.txt' file with the include paths.
                pkgs.writeText "compile_flags.txt"
                (builtins.concatStringsSep " " (builtins.map (x: "-isystem ${x}") include_paths))
            } $out/compile_flags.txt
        '';
    };

    # Create a wrapper script to pass the directory of "compile_flags.txt" to clangd.
    script = pkgs.writeScriptBin "clangd" ''
        ${src}/bin/clangd --compile-commands-dir="${compile_flags}" $@
    '';

in
stdenv.mkDerivation rec {
    inherit src name;

    buildPhase = "";

    installPhase = ''
        mkdir -p $out/bin
        cp ${script}/bin/clangd "$out/bin/${name}"
    '';
}

