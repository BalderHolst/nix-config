{ pkgs ? import <nixpkgs> { } }:

let
  inherit (pkgs) stdenv;

  # The path to the npm project
  src = pkgs.fetchFromGitHub {
      owner = "mathworks";
      repo = "MATLAB-language-server";
      rev = "e6e87cc9d04d9fb6b8731b7f8905f8de7677f952";
      sha256 = "sha256-KRVkBXhK/09IEtdG9K2pyfJ3oN12TNq0DXKdgSYcHK4=";
  };

  # Read the package-lock.json as a Nix attrset
  packageLock = builtins.fromJSON (builtins.readFile (src + "/package-lock.json"));

  # Create an array of all (meaningful) dependencies
  deps = builtins.attrValues (removeAttrs packageLock.packages [ "" ]) ++ builtins.attrValues (removeAttrs packageLock.dependencies [ "" ])
  ;

  # Turn each dependency into a fetchurl call
  balls = map (p: pkgs.fetchurl { url = p.resolved; hash = p.integrity; }) deps;

  installScript = pkgs.writeShellScript "install" (builtins.concatStringsSep " & \n" (map (p: 
  ''echo "caching: ${p}" && npm cache add "${p}" && echo "DONE: ${p}"''
  ) balls));

  startScript = pkgs.writeShellScript "start" ''
  DIR="$(dirname $(readlink -f $0))/.."
  NODE_PATH=$DIR/node_modules
  node $DIR/out/index.js --stdio
  '';

in
stdenv.mkDerivation rec {
  pname = "matlab-lsp";

  inherit (packageLock) name version;
  inherit src;

  buildInputs =  [
    pkgs.nodejs
    pkgs.gnutar
  ];
  buildPhase = ''
    echo "Building"

    export HOME=$PWD/.home
    export npm_config_cache=$PWD/.npm

    mkdir -p node_modules

    eval "${installScript}"
    npm ci
    webpack=$PWD/node_modules/.bin/webpack
    node $webpack --mode production --devtool hidden-source-map
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp -rf . "$out"
    cp -fv ${startScript} "$out/bin/matlab-lsp"
  '';
}

