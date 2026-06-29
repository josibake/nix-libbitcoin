# nix-libbitcoin

Nix packages and a NixOS module for running the libbitcoin v4 development
server.

The upstream libbitcoin v4 stack is currently developed on `master` across
multiple repositories. This flake pins the current `master` commits explicitly
instead of using moving branch refs.

## Packages

The default package is `libbitcoin-server`, which installs the `bs` daemon.
Packages are built through upstream's CMake files in `builds/cmake`.

```shell
nix build
./result/bin/bs --settings
```

Build from a local multi-repo checkout instead of the pinned GitHub commits:

```shell
LIBBITCOIN_LOCAL_ROOT=~/libbitcoin nix build --impure .#local-libbitcoin-server --print-build-logs
```

`LIBBITCOIN_LOCAL_ROOT` should point at the directory that contains `repos/`.

Available packages:

- `libbitcoin-system`
- `libbitcoin-database`
- `libbitcoin-network`
- `libbitcoin-node`
- `libbitcoin-server`

The package set also contains `secp256k1CmakeConfig`, a small CMake package
config shim for nixpkgs' `secp256k1`. nixpkgs already provides the library, but
libbitcoin's CMake files expect `find_package(libsecp256k1)` and the imported
target `libsecp256k1::secp256k1`.

## NixOS

Import the module and overlay from this flake:

```nix
{
  inputs.nix-libbitcoin.url = "github:josibake/nix-libbitcoin";

  outputs = {nixpkgs, nix-libbitcoin, ...}: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nix-libbitcoin.nixosModules.default
        {
          nixpkgs.overlays = [nix-libbitcoin.overlays.default];

          services.libbitcoin-server = {
            enable = true;
            openFirewall = true;
            settings.inbound.bind = ["0.0.0.0:8333"];
          };
        }
      ];
    };
  };
}
```

The service writes its generated configuration to the Nix store and runs:

```shell
bs --config <generated-config>
```

`services.libbitcoin-server.settings` models the upstream `bs` configuration
surface from the pinned `libbitcoin-server` parser as typed Nix options. Set
`services.libbitcoin-server.configFile` if you want to provide a complete
configuration file yourself, or use `extraConfig` for settings not yet covered
after a future upstream change.

## Development

Format Nix files with:

```shell
nix fmt
```

The flake formatter uses `treefmt-nix` to run the official Nix formatter.

Run evaluation checks without building the C++ packages:

```shell
nix flake check --no-build --all-systems
```

## Silent Payments Load Benchmark

The flake includes a small Electrum JSON-RPC load driver for iterating on
silent payments scan performance against a local or remote `bs` instance:

```shell
nix run .#sp-load -- \
  --host 127.0.0.1 \
  --port 50001 \
  --scan-private-key <32-byte-hex-scan-secret> \
  --spend-public-key <33-byte-hex-spend-public-key> \
  --start 709632 \
  --requests 16 \
  --clients 4
```

Use `--stop <height>` for bounded scan windows, `--labels 1,2,3` for labelled
wallet scans, and `--json-out report.json` when comparing runs.

Probe only the Electrum handshake and feature advertisement with:

```shell
nix run .#sp-load -- --host 127.0.0.1 --port 50001 --probe-only
```
