{ rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "blatex";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "BalderHolst";
    repo = "blatex";
    rev = "9a0ce4a61336b6087d32d8df891c232f5ffbb191";
    sha256 = "sha256-kGAtuP3+aY6dDU9IbvN9H6Znpf5PvMyg4ZScWRa7kR8=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
        "texlog-0.1.0" = "sha256-jpOaj3xS4cfyQvjYgCsJWX5lwpeFPmuk29Yl74HcBDY=";
    };
  };

  doCheck = false;
  cargoHash = "";
  cargoDepsName = pname;
}
