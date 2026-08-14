{ rustPlatform, fetchFromGitHub, lib, pkg-config, openssl }:

let
    src = fetchFromGitHub {
      owner = "typst";
      repo = "package-check";
      rev = "v0.6.0";
      hash = "sha256-7nGSXcUMR28grAH9Z3C7vy4tEGmlnmM9VsAdnvJEc30=";
    };
    manifest = (lib.importTOML (src + "/Cargo.toml")).package;
in
rustPlatform.buildRustPackage rec {
    inherit src;
    pname = manifest.name;
    version = manifest.version;
    cargoHash = "sha256-RMjZLacXHStsPyK5R0T++mr2yLlJE52xpcK1sqJ57Fw=";
    cargoDepsName = pname;
    nativeBuildInputs = [ pkg-config ];
    buildInputs = [ openssl ];
}
