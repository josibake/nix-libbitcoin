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
      localRootEnv = builtins.getEnv "LIBBITCOIN_LOCAL_ROOT";
      localRoot =
        if localRootEnv == ""
        then throw "Set LIBBITCOIN_LOCAL_ROOT to the multi-repo checkout, e.g. /Users/josibake/libbitcoin"
        else /. + localRootEnv;
      localLibbitcoinPackages = pkgs.callPackage ./pkgs/libbitcoin {
        inherit localRoot;
      };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in {
      packages = {
        inherit (libbitcoinPackages) libbitcoin-system libbitcoin-database libbitcoin-network libbitcoin-node libbitcoin-server;
        default = libbitcoinPackages.libbitcoin-server;
        local-libbitcoin-system = localLibbitcoinPackages.libbitcoin-system;
        local-libbitcoin-database = localLibbitcoinPackages.libbitcoin-database;
        local-libbitcoin-network = localLibbitcoinPackages.libbitcoin-network;
        local-libbitcoin-node = localLibbitcoinPackages.libbitcoin-node;
        local-libbitcoin-server = localLibbitcoinPackages.libbitcoin-server;
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
