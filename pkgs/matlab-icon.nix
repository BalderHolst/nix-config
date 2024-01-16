{ configDir, lib, makeDesktopItem }:

makeDesktopItem {
    name = "matlab";
    desktopName = "Matlab";
    exec = "${configDir}/user/utils/matlab -desktop";
    icon = builtins.fetchurl {
        url = "https://assets.nvidiagrid.net/ngc/logos/ISV-OSS-Non-Nvidia-Publishing-Matlab.png";
        sha256 = "sha256:1vndz151x9f1lnwl9xl8k30ib1fn1bzkpz1b9a08dg1l27slazsx";
    };
}
