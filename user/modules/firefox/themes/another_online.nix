{ pkgs, ... }:
rec {
    src = pkgs.fetchFromGitHub {
      owner = "mimipile";
      repo = "firefoxCSS";
      rev = "29c87c7490a244c767adc1d60fbb63ae61939dde";
      hash = "sha256-jrcRhK/ml+zStvrOrBq5iDNt51F/VdErcPl9+QkLtB4=";
    };
    userChrome = src + "/userChrome.css";
    userJs = "";
}
