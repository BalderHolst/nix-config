{ pkgs, lib, config, ... }:
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
    cfg = config.embedded.avr;
in
{

    options.embedded.avr = {
        enable = lib.mkEnableOption "AVR support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            avrdude       # burn programs to avr platforms
            avrdudess     # GUI for avr-dude
            avr-toolchain # defined above
            avra          # AVR assembler
        ];
    };
}
