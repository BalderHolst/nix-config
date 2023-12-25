{ configDir, lib, makeDesktopItem }:

makeDesktopItem {
    name = "matlab";
    desktopName = "Matlab";
    exec = "${configDir}/user/utils/matlab -desktop";
    icon = builtins.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Matlab_Logo.png/667px-Matlab_Logo.png";
        sha256 = "sha256:1379d2pdm49hcq9gib47jd7jrp2926h69an5jjgfh60rwnhgrslx";
    };
}
