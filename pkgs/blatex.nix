{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "blatex";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "BalderHolst";
    repo = "blatex";
    rev = "704e505b2389689e80fb0b2dc0dbe5ae1d719494";
    sha256 = "sha256-rgV/r7/sPA11zu9Hv7hQBLLIfjXHWidCOqOWKGtwaE0=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
        "texlog-0.1.0" = "sha256-jpOaj3xS4cfyQvjYgCsJWX5lwpeFPmuk29Yl74HcBDY=";
    };
  };

  doCheck = false;
  cargoDepsName = pname;
}
