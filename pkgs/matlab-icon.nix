{ userHome, lib, makeDesktopItem }:

makeDesktopItem {
    name = "matlab";
    desktopName = "Matlab";
    exec = "${userHome}/.config/home-manager/utils/matlab -desktop";
    icon = builtins.fetchurl {
        url = "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Matlab_Logo.png/667px-Matlab_Logo.png";
        sha256 = "sha256:02xrimzr62nxwysbirxgbsr030a6n4cji1vffx2cziax64g2f39q";
    };
}
