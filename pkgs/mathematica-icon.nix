{ userHome, lib, makeDesktopItem }:

makeDesktopItem {
    name = "mathematica";
    desktopName = "Mathematica";
    exec = "${userHome}/.config/home-manager/impure/mathematica/result/bin/mathematica";
    icon = builtins.fetchurl {
        url = "https://eits.uga.edu/_resources/files/images/mathematica-11-spikey.png";
        sha256 = "sha256:1m0m20n26lyicnrjnzm6sng5w431lg64cqrzv0lwawkgv7dq4w0k";
    };
}
