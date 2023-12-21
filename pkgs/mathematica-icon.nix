{ mathematicaPath, lib, makeDesktopItem }:

makeDesktopItem {
    name = "mathematica";
    desktopName = "Mathematica";
    exec = "env QT_XCB_GL_INTEGRATION=none ${mathematicaPath}";
    icon = builtins.fetchurl {
        url = "https://eits.uga.edu/_resources/files/images/mathematica-11-spikey.png";
        sha256 = "sha256:1m0m20n26lyicnrjnzm6sng5w431lg64cqrzv0lwawkgv7dq4w0k";
    };
}
