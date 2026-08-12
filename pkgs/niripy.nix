{ pydantic, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
    pname = "niripy";
    version = "0.2.7";
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      dist = "py3"; # Forces /packages/py3/ instead of /packages/py2.py3/
      python = "py3";
      abi = "none";
      platform = "any";
      sha256 = "sha256-xKv+pHTVVk8Kt0p8IP1M9KUoVPwaQlD1KvUw+dyDvgk=";
    };

    propagatedBuildInputs = [
        pydantic
    ];
  }
