{
  callPackage,
  fetchFromGitHub,
  secp256k1,
  localRoot ? null,
}: rec {
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
  common = callPackage ./common.nix {
    secp256k1 = secp256k1_0_7;
    inherit secp256k1CmakeConfig localRoot;
  };

  libbitcoin-system = callPackage ./system.nix {inherit common;};
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
