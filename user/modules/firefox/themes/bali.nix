{ pkgs, lib, ... }:
rec {
    src = pkgs.fetchFromGitHub {
      owner = "Bali10050";
      repo = "firefoxCSS";
      rev = "4568127746f286a0ae7fb5ca9a20fdaeb5d5e0f1";
      hash = "sha256-7IIPRBULSxhUCkwOFdt15bt2H2QM6YEpAZxW0et6pW4=";
    };
    userChrome = src + "/chrome/userChrome.css";
    userJs = lib.readFile (src + "/user.js");
}
