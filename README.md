# nix-libbitcoin

minimal flake for building a runnable libbitcoin-node. for personal use, etc etc

## to use

```shell
git clone git@github.com:josibake/nix-libbitcoin.git
cd nix-libbitcoin

nix build
```

This will compile `libbitcoin-node` and put the build output in `result/`. You can then run the node with:

```shell
./result/bin/bn --config ./examples/bn.cfg
```

The included `bn.cfg` is more or less just taking the default values (you can see all the options with `bn --settings`).
