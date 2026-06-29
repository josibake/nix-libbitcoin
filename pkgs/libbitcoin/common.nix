{
  stdenv,
  ccacheStdenv,
  lib,
  fetchFromGitHub,
  cmake,
  boost186,
  secp256k1,
  ultrafastSecp256k1,
  secp256k1CmakeConfig,
  localRoot ? null,
  localSources ? { },
  withTests ? false,
  withUltrafast ? false,
  useCcache ? false,
  ccacheDir ? "/var/cache/ccache",
  ccacheMaxSize ? "50G",
}:
let
  version = "4.0.0-unstable-2026-05-29";
  buildStdenv =
    if useCcache then
      ccacheStdenv.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR=${ccacheDir}
          export CCACHE_MAXSIZE=${ccacheMaxSize}
          export CCACHE_UMASK=007
        '';
      }
    else
      stdenv;
  localSource =
    repo:
    if builtins.hasAttr repo localSources then
      localSources.${repo}
    else if localRoot != null then
      builtins.path {
        path = localRoot + "/repos/${repo}";
        name = "source";
      }
    else
      throw "No local source configured for ${repo}";
  hasLocalSources = localRoot != null || localSources != { };
in
{
  mkLibbitcoin =
    {
      pname,
      repo ? pname,
      rev,
      hash,
      nativeBuildInputs ? [ ],
      buildInputs ? [ ],
      propagatedBuildInputs ? [ ],
      cmakeFlags ? [ ],
      patches ? [ ],
      patchRoot ? ".",
      meta ? { },
    }:
    buildStdenv.mkDerivation {
      inherit pname version patches;

      src =
        if !hasLocalSources then
          fetchFromGitHub {
            owner = "libbitcoin";
            inherit repo rev;
            sha256 = hash;
          }
        else
          localSource repo;

      sourceRoot = "source/builds/cmake";

      nativeBuildInputs = [ cmake ] ++ nativeBuildInputs;
      buildInputs = [
        boost186
        secp256k1
        secp256k1CmakeConfig
      ]
      ++ lib.optionals withUltrafast [ ultrafastSecp256k1 ]
      ++ buildInputs;
      propagatedBuildInputs = propagatedBuildInputs;
      NIX_CFLAGS_COMPILE = lib.optionalString (
        withUltrafast && pname == "libbitcoin-system"
      ) "-DWITH_ULTRAFAST";
      NIX_LDFLAGS = lib.optionalString (
        withUltrafast && pname == "libbitcoin-system"
      ) "-L${ultrafastSecp256k1}/lib -lufsecp";
      doCheck = withTests;
      prePatch = ''
        chmod -R u+w ${lib.escapeShellArg patchRoot}
      ''
      + lib.optionalString (patchRoot != ".") ''
        pushd ${patchRoot}
      '';
      postPatch = lib.optionalString (patchRoot != ".") ''
        popd
      '';

      cmakeFlags = [
        "-DBUILD_SHARED_LIBS=ON"
        "-Dwith-tests=${if withTests then "ON" else "OFF"}"
      ]
      ++ lib.optionals withUltrafast [ "-Dwith-ultrafast=ON" ]
      ++ cmakeFlags;

      checkPhase = ''
        runHook preCheck
        ctest --output-on-failure
        runHook postCheck
      '';

      enableParallelBuilding = true;

      meta = {
        homepage = "https://github.com/libbitcoin/${repo}";
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.unix;
      }
      // meta;
    };
}
