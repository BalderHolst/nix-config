{ pkgs, ... }:
{

    imports = [
        ./avr.nix
        ./tiva.nix
        ./yosys.nix
        ./arduino.nix
        ./pico.nix
    ];

    config = {
        home.packages = with pkgs; [
            cutecom # serial terminal
        ];
    };
}
