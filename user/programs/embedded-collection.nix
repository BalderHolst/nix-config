{ pkgs, ... }:
let
    inherit (pkgs) stdenv;
    avr-toolchain = stdenv.mkDerivation {
        name = "avr-toolchain";
        src = pkgs.pkgsCross.avr.buildPackages.gcc;
        installPhase = ''
            mkdir -p "$out"
            cp -rv "$src/bin" "$out/bin"
        '';
    };
in
{
    home.packages = with pkgs; [

        cutecom # serial terminal

        # AVR
        avrdude # burn programs to avr platforms
        avrdudess # GUI for avr-dude
        avr-toolchain # defined above
        avra # AVR assembler

        # Arduino
        arduino # arduino ide
        arduino-cli # arduino ide

        # Tivaware
        gcc-arm-embedded-9 # toolchain
        (pkgs.callPackage ../../pkgs/lm4flash.nix { }) # flashing tool
        glibc

        # FPGA (https://github.com/YosysHQ/oss-cad-suite-build?tab=readme-ov-file)
        (pkgs.callPackage ../../pkgs/oss-cad-suite.nix { }) # flashing tool
    ];
}
