{ rustPlatform, fetchFromGitHub, installShellFiles  }:

rustPlatform.buildRustPackage rec {
  pname = "blatex";
  version = "0.1.0";

  nativeBuildInputs = [ installShellFiles ];

  src = fetchFromGitHub {
    owner = "BalderHolst";
    repo = "blatex";
    rev = "166bad3c239509e80e626277b309a5fca5675624";
    sha256 = "sha256-iVEwUo1MkGfqduxh6rEBU8ZaryRb7xQI7q2lklV9fMM=";
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
