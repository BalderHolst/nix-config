{ pkgs, lib, config, ... }:
let
    cfg = config.embedded.pico;

    pico-sdk = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "pico-sdk";
      fetchSubmodules = true;
      rev = "a1438dff1d38bd9c65dbd693f0e5db4b9ae91779";
      sha256 = "sha256-8ubZW6yQnUTYxQqYI6hi7s3kFVQhe5EaxVvHmo93vgk=";
    };

in
{

    options.embedded.pico = {
        enable = lib.mkEnableOption "Raspberry Pi PICO support";
    };

    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            cmake            # Build tool
            minicom          # Serial terminal
            picotool         # Upload binaries to PICO
            mpremote         # Upload and execute micropython files
            gcc-arm-embedded # Arm cross compiler
        ];

        home.sessionVariables."PICO_SDK_PATH" = pico-sdk;
    };
}
