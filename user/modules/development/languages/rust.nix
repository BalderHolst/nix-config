{ pkgs, lib, config, ... }:
let
    cfg = config.lang.rust;
    rust-toolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" "clippy"];
        targets = [ "arm-unknown-linux-gnueabihf" ];
    };
in
{

    options.lang.rust = {
        enable = lib.mkEnableOption "Rust programming language support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            rust-toolchain # rust build toolchain
            cargo-expand   # expand macros
        ];
    };
}
