{
  description = "flake for building libbitcoin-node";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    libbitcoin-system = pkgs.callPackage ./system/package.nix {};
    libbitcoin-database = pkgs.callPackage ./database/package.nix {
      inherit libbitcoin-system;
    };
    libbitcoin-network = pkgs.callPackage ./network/package.nix {
      inherit libbitcoin-system;
    };
    libbitcoin-node = pkgs.callPackage ./node/package.nix {
      inherit libbitcoin-system libbitcoin-database libbitcoin-network;
    };
  in {
    packages.${system} = {
      inherit libbitcoin-system libbitcoin-database libbitcoin-network libbitcoin-node;
      default = libbitcoin-node;
    };

    formatter.${system} = pkgs.alejandra;
  };
}
