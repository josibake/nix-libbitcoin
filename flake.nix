{
  description = "Packages and NixOS module for libbitcoin-server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    treefmt-nix,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-darwin"];

    perSystem = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      libbitcoinPackages = pkgs.callPackage ./pkgs/libbitcoin {};
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in {
      packages = {
        inherit (libbitcoinPackages) libbitcoin-system libbitcoin-database libbitcoin-network libbitcoin-node libbitcoin-server;
        default = libbitcoinPackages.libbitcoin-server;
      };
      checks = {
        formatting = treefmtEval.config.build.check self;
      };
      formatter = treefmtEval.config.build.wrapper;
    };

    allSystems = nixpkgs.lib.genAttrs supportedSystems perSystem;
  in {
    packages = nixpkgs.lib.mapAttrs (_: v: v.packages) allSystems;
    checks = nixpkgs.lib.mapAttrs (_: v: v.checks) allSystems;
    formatter = nixpkgs.lib.mapAttrs (_: v: v.formatter) allSystems;
    overlays.default = final: prev: {
      libbitcoinPackages = final.callPackage ./pkgs/libbitcoin {};
      inherit
        (final.libbitcoinPackages)
        libbitcoin-system
        libbitcoin-database
        libbitcoin-network
        libbitcoin-node
        libbitcoin-server
        ;
    };
    nixosModules = rec {
      default = libbitcoin-server;
      libbitcoin-server = ./modules/services/libbitcoin-server.nix;
    };
  };
}
