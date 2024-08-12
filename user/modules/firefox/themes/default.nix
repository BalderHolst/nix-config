{ pkgs, ... }:
rec {
    userChrome = pkgs.writeText "userChrome.css" "";
    userJs = "";
}
