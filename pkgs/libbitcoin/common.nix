{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  boost186,
  secp256k1,
  secp256k1CmakeConfig,
  localRoot ? null,
}: let
  version = "4.0.0-unstable-2026-05-29";
  localSource = repo:
    builtins.path {
      path = localRoot + "/repos/${repo}";
      name = "source";
    };
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

      src =
        if localRoot == null
        then
          fetchFromGitHub {
            owner = "libbitcoin";
            inherit repo rev;
            sha256 = hash;
          }
        else localSource repo;

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
