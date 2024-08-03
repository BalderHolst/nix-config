{ lib, ... }:
rec {
    userChrome = lib.writeText "userChrome.css" "";
    userJs = lib.writeText "user.js" "";
}
