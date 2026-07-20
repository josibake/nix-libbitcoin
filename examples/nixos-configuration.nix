{ inputs, ... }:
{
  imports = [
    inputs.nix-libbitcoin.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.nix-libbitcoin.overlays.default
  ];

  services.libbitcoin-server = {
    enable = true;
    openFirewall = true;
    settings = {
      network = {
        bind = "0.0.0.0:8333";
      };
    };
  };
}
