{ rustPlatform, fetchFromGitHub, installShellFiles  }:

rustPlatform.buildRustPackage rec {
  pname = "blatex";
  version = "0.1.0";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "BalderHolst";
    repo = "blatex";
    rev = "aae32ad93c2e6e4b8d2d6cb0925c42ea9e8c73b0";
    sha256 = "sha256-wPWK7etyUmGNqNVaSkAxje+bJ5scXDx+/kcgi9ddyJw=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
        "texlog-0.1.0" = "sha256-jpOaj3xS4cfyQvjYgCsJWX5lwpeFPmuk29Yl74HcBDY=";
    };
  };

  postInstall = ''
    mkdir -p $out/share/man/man1
    installManPage $src/man/blatex.1
  '';

  doCheck = false;
  cargoDepsName = pname;
}
