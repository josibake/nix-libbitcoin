{
  stdenv,
  fetchFromGitHub,
  # needs pinned to boost186 - seems to_iv4 (and possibly more)
  # methods were removed in 1.87 (which is the current boost in nixpkgs)
  boost186,
  autoreconfHook,
  pkg-config,
  secp256k1,
}:
stdenv.mkDerivation {
  name = "libbitcoin-system";
  version = "master";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = "libbitcoin-system";
    rev = "665d7990df1d93d1cc7a6c57a4550ebd1db27e2e";
    sha256 = "sha256-y8/ytPAD9mZVOhrDhzVPJkvvwTLFO+YvI517+KE+5o4";
  };
  # found on the nixos.wiki, apparently autotools is not supported
  # out of the box, so a special hook is required
  nativeBuildInputs = [autoreconfHook pkg-config];
  buildInputs = [boost186 secp256k1];
  # cant seem to find the correct boost stuff automagically,
  # so we explicitly set the boost lib directory
  configureFlags = [
    "--with-boost-libdir=${boost186.out}/lib"
  ];
  # im not sure we need this line, but keeping it for now
  makeFlags = ["prefix=${placeholder "out"}"];
  enableParallelBuilding = true;
}
