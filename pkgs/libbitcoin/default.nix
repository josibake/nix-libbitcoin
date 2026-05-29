{callPackage}: rec {
  secp256k1CmakeConfig = callPackage ./secp256k1-cmake-config.nix {};
  common = callPackage ./common.nix {inherit secp256k1CmakeConfig;};

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
