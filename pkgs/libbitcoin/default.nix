{
  callPackage,
  fetchFromGitHub,
  secp256k1,
  cudaPackages,
  localRoot ? null,
  localSources ? { },
  withCuda ? false,
  enableXcpu ? false,
  withTests ? false,
  useCcache ? false,
  ccacheDir ? "/var/cache/ccache",
  ccacheMaxSize ? "50G",
  cudaArchitectures ? null,
  withUltrafast ? false,
  systemPatches ? [ ],
}:
rec {
  secp256k1_0_7 = secp256k1.overrideAttrs (_old: rec {
    version = "0.7.0";
    src = fetchFromGitHub {
      owner = "bitcoin-core";
      repo = "secp256k1";
      rev = "v${version}";
      hash = "sha256-V9hm96NJl6ppE9TPCo7/ezs6bw0CEQMFMfIAo0WzDLQ=";
    };
  });

  secp256k1CmakeConfig = callPackage ./secp256k1-cmake-config.nix {
    secp256k1 = secp256k1_0_7;
  };
  ultrafastSecp256k1 = callPackage ./ultrafast-secp256k1.nix {
    inherit
      cudaPackages
      withCuda
      cudaArchitectures
      useCcache
      ccacheDir
      ccacheMaxSize
      ;
  };
  common = callPackage ./common.nix {
    secp256k1 = secp256k1_0_7;
    inherit
      ultrafastSecp256k1
      secp256k1CmakeConfig
      localRoot
      localSources
      withTests
      withUltrafast
      useCcache
      ccacheDir
      ccacheMaxSize
      ;
  };

  libbitcoin-system = callPackage ./system.nix { inherit common enableXcpu systemPatches; };
  libbitcoin-database = callPackage ./database.nix {
    inherit common libbitcoin-system;
  };
  libbitcoin-network = callPackage ./network.nix {
    inherit common libbitcoin-system;
  };
  libbitcoin-node = callPackage ./node.nix {
    inherit common libbitcoin-database libbitcoin-network;
  };
  libbitcoin-server = callPackage ./server.nix {
    inherit common libbitcoin-node;
  };
}
