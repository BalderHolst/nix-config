{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "blatex";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "BalderHolst";
    repo = "blatex";
    rev = "b9b860d4006300b7fc7363ccff327b58102dca26";
    sha256 = "sha256-kJ9u1QVWo/PoDf0qxzixRGiaNs6Dc199qbZ/pzUIDMg=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
        "texlog-0.1.0" = "sha256-jpOaj3xS4cfyQvjYgCsJWX5lwpeFPmuk29Yl74HcBDY=";
    };
  };

  cargoHash = "";
  cargoDepsName = pname;
}
