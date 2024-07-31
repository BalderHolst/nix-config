{ pkgs, ... }:
rec {
    src = pkgs.fetchFromGitHub {
      owner = "RemyIsCool";
      repo = "AnimatedFox";
      rev = "ac8759402b4017b2258c9166b57af9749ac2328d";
      hash = "sha256-8jhQRj1C4vbM85ekne+f+Pjh8Pnjc2lEYU6mkGMEdNc=";
    };
    userChrome = src + "/userChrome.css";
    userJs = "";
}
