{ pkgs ? import <nixpkgs> { } }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "vhdl_ls";
  version = "0.77.0";

  src = pkgs.fetchFromGitHub {
    owner = "VHDL-LS";
    repo = "rust_hdl";
    rev = "924ab79481381b61f915e406d4918c78c9ee6643";
    sha256 = "sha256-8WDg34s+fpgOFTkoqrGMAdt/vE6uAlEM1gtZbCPdOFM=";
  };

  cargoHash = "sha256-9q/1s8QzIpYwhbrmLOXeO3/8s3sItKmOhabP33J7yeI=";
  cargoDepsName = pname;
  doCheck = false;
}
