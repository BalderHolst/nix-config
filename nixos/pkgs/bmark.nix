{ lib, rustPlatform, fetchCrate  }:

rustPlatform.buildRustPackage rec {
  pname = "bmark";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-wmuYPLG67G9ciZKc0dCIBWDOWYaN02sIvU2pOpveBSg=";
  };

  cargoHash = "sha256-14iRsvQwb/TcxrD7FI6iAQnwohVUIUQiosBvn72YCdU=";
  cargoDepsName = pname;
}
