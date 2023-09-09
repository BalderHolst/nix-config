{ stdenv, fetchFromGitHub, pkgs }:

{
  dialog = stdenv.mkDerivation rec {
    pname = "sddm-theme-dialog";
    version = "53f81e3";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/dialog
    '';
    src = fetchFromGitHub {
      owner = "joshuakraemer";
      repo = "sddm-theme-dialog";
      rev = "53f81e322f715d3f8e3f41c38eb3774b1be4c19b";
      sha256 = "qoLSRnQOvH3rAH+G1eRrcf9ZB6WlSRIZjYZBOTkew/0=";
    };
  };

  sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-theme-sugar-dark";
    version = "1.2";
    config = ./sugar-dark.conf;
    dontBuild = true;
    installPhase = ''
      theme_path="$out/share/sddm/themes/sugar-dark"
      mkdir -p "$theme_path"
      find $src/ ! -name theme.conf -exec cp -aR -t $theme_path {} +
      cp -a ${config} $out/share/sddm/themes/sugar-dark/theme.conf
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };
}
