{
  description = "Packages and NixOS module for libbitcoin-server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          libbitcoinPackages = pkgs.callPackage ./pkgs/libbitcoin { };
          localRootEnv = builtins.getEnv "LIBBITCOIN_LOCAL_ROOT";
          hasLocalRoot = localRootEnv != "";
          localRoot = if hasLocalRoot then /. + localRootEnv else null;
          ccacheEnv = builtins.getEnv "LIBBITCOIN_CCACHE";
          useCcache = ccacheEnv == "1" || ccacheEnv == "true";
          ccacheDirEnv = builtins.getEnv "LIBBITCOIN_CCACHE_DIR";
          ccacheDir = if ccacheDirEnv == "" then "/var/cache/ccache" else ccacheDirEnv;
          cudaEnv = builtins.getEnv "LIBBITCOIN_CUDA";
          withCuda = cudaEnv == "1" || cudaEnv == "true";
          xcpuEnv = builtins.getEnv "LIBBITCOIN_XCPU";
          enableXcpu = xcpuEnv == "1" || xcpuEnv == "true";
          treefmtEval = treefmt-nix.lib.evalModule pkgs {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };
          localLibbitcoinPackages =
            if hasLocalRoot then
              pkgs.callPackage ./pkgs/libbitcoin {
                inherit
                  localRoot
                  withCuda
                  enableXcpu
                  useCcache
                  ccacheDir
                  ;
              }
            else
              { };
          localLibbitcoinTestPackages =
            if hasLocalRoot then
              pkgs.callPackage ./pkgs/libbitcoin {
                inherit
                  localRoot
                  withCuda
                  enableXcpu
                  useCcache
                  ccacheDir
                  ;
                withTests = true;
              }
            else
              { };
        in
        {
          packages = {
            inherit (libbitcoinPackages)
              ultrafastSecp256k1
              libbitcoin-system
              libbitcoin-database
              libbitcoin-network
              libbitcoin-node
              libbitcoin-server
              ;
            default = libbitcoinPackages.libbitcoin-server;
          }
          // nixpkgs.lib.optionalAttrs hasLocalRoot {
            local-libbitcoin-system = localLibbitcoinPackages.libbitcoin-system;
            local-libbitcoin-database = localLibbitcoinPackages.libbitcoin-database;
            local-libbitcoin-network = localLibbitcoinPackages.libbitcoin-network;
            local-libbitcoin-node = localLibbitcoinPackages.libbitcoin-node;
            local-libbitcoin-server = localLibbitcoinPackages.libbitcoin-server;
            local-libbitcoin-system-tests = localLibbitcoinTestPackages.libbitcoin-system;
            local-libbitcoin-database-tests = localLibbitcoinTestPackages.libbitcoin-database;
            local-libbitcoin-network-tests = localLibbitcoinTestPackages.libbitcoin-network;
            local-libbitcoin-node-tests = localLibbitcoinTestPackages.libbitcoin-node;
            local-libbitcoin-server-tests = localLibbitcoinTestPackages.libbitcoin-server;
          };
          apps = {
            sp-load = {
              type = "app";
              program = toString (
                pkgs.writeShellScript "sp-load" ''
                  exec ${pkgs.python3}/bin/python3 ${./bench/silentpayments_electrum_load.py} "$@"
                ''
              );
              meta.description = "Run a Silent Payments Electrum JSON-RPC load benchmark";
            };
          };
          checks = {
            formatting = treefmtEval.config.build.check self;
          };
          formatter = treefmtEval.config.build.wrapper;
        };

      allSystems = nixpkgs.lib.genAttrs supportedSystems perSystem;
    in
    {
      packages = nixpkgs.lib.mapAttrs (_: v: v.packages) allSystems;
      apps = nixpkgs.lib.mapAttrs (_: v: v.apps) allSystems;
      checks = nixpkgs.lib.mapAttrs (_: v: v.checks) allSystems;
      formatter = nixpkgs.lib.mapAttrs (_: v: v.formatter) allSystems;
      overlays.default = final: prev: {
        libbitcoinPackages = final.callPackage ./pkgs/libbitcoin { };
        inherit (final.libbitcoinPackages)
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
