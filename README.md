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

Run evaluation checks without building the C++ packages:

```shell
nix flake check --no-build --all-systems
```

Run only the formatting check:

```shell
nix build .#checks.$(nix eval --raw --impure --expr builtins.currentSystem).formatting --no-link
```
