{
  description = "flake for building libbitcoin-node";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

    perSystem = system: let
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
      packages = {
        inherit libbitcoin-system libbitcoin-database libbitcoin-network libbitcoin-node;
        default = libbitcoin-node;
      };
      formatter = pkgs.alejandra;
    };

    allSystems = nixpkgs.lib.genAttrs supportedSystems perSystem;
  in {
    packages = nixpkgs.lib.mapAttrs (_: v: v.packages) allSystems;
    formatter = nixpkgs.lib.mapAttrs (_: v: v.formatter) allSystems;
  };
}
