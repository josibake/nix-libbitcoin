{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  boost186,
  secp256k1,
  secp256k1CmakeConfig,
}: let
  version = "4.0.0-unstable-2026-05-29";
in {
  mkLibbitcoin = {
    pname,
    repo ? pname,
    rev,
    hash,
    nativeBuildInputs ? [],
    buildInputs ? [],
    propagatedBuildInputs ? [],
    cmakeFlags ? [],
    patches ? [],
    meta ? {},
  }:
    stdenv.mkDerivation {
      inherit pname version patches;

      src = fetchFromGitHub {
        owner = "libbitcoin";
        inherit repo rev;
        sha256 = hash;
      };

      sourceRoot = "source/builds/cmake";

      nativeBuildInputs = [cmake] ++ nativeBuildInputs;
      buildInputs = [boost186 secp256k1 secp256k1CmakeConfig] ++ buildInputs;
      propagatedBuildInputs = propagatedBuildInputs;

      cmakeFlags =
        [
          "-DBUILD_SHARED_LIBS=ON"
          "-Dwith-tests=OFF"
        ]
        ++ cmakeFlags;

      enableParallelBuilding = true;

      meta =
        {
          homepage = "https://github.com/libbitcoin/${repo}";
          license = lib.licenses.agpl3Plus;
          platforms = lib.platforms.unix;
        }
        // meta;
    };
}
