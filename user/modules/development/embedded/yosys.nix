{ pkgs, lib, config, ... }:
let
    cfg = config.embedded.yosys;
in
{
    options.embedded.yosys = {
        enable = lib.mkEnableOption "YosysHQ OSS CAD Suite for FPGA";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            # FPGA (https://github.com/YosysHQ/oss-cad-suite-build?tab=readme-ov-file)
            (pkgs.callPackage ../../../../pkgs/oss-cad-suite.nix { })
        ];
    };
}
