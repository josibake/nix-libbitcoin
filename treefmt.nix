{
  projectRootFile = "flake.nix";

  programs.alejandra.enable = true;

  settings.formatter.alejandra.includes = ["*.nix"];
}
