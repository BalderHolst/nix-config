{ pkgs ? import <nixpkgs> { }, ... }:

let
    ubuntu = pkgs.dockerTools.pullImage {
        imageName = "ubuntu";
        sha256 = "sha256-RkDJV3b0upHE+thZM7jIiIGnS8afnUU37ZiQtDcyyf0=";
        imageDigest = "sha256:81bba8d1dde7fc1883b6e95cd46d6c9f4874374f2b360c8db82620b33f6b5ca1";
    };
    file = pkgs.writeText "test.txt" ''
    This is a test file!
    '';
in
pkgs.dockerTools.buildImage {
    name = "ubuntu";
    tag = "22.04";

    fromImage = ubuntu;

    runAsRoot = ''
    #!${pkgs.runtimeShell}
    cp ${file} /test.txt
    ln -s ${pkgs.firefox}/bin/firefox /bin/firefox
    '';
    
    config = {
        Cmd = "${pkgs.neofetch}/bin/neofetch";
        Env = [
            "DISPLAY=:1"
        ];
        Volumes = {
            "/tmp/.X11-unix" = { };
        };
    };
    #networkMode = "host";
}
