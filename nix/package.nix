{ stdenv, ... }:
let
  name = "rrv.sh";
  version = "0.0.1";
in
stdenv.mkDerivation {
  inherit name version;
  src = ../src;
  installPhase = ''
    cp -r . $out
  '';
}
