{
  stdenv,
  fetchFromGitHub,
  libbitcoin-system,
  autoreconfHook,
  pkg-config,
  boost186,
  secp256k1,
}:
stdenv.mkDerivation {
  name = "libbitcoin-network";
  version = "master";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = "libbitcoin-network";
    rev = "master";
    sha256 = "sha256-MWYRtOGyoX2EnMWSz7t6nDqagZdIQ/raiYPKwD3UlIw";
  };

  # this is a straight copy from the libbitcoin-system flake
  # id prefer if we can pass this along but would will leave
  # as a follow-up for now
  nativeBuildInputs = [autoreconfHook pkg-config];
  buildInputs = [boost186 secp256k1 libbitcoin-system];
  configureFlags = [
    "--with-boost-libdir=${boost186.out}/lib"
  ];

  makeFlags = ["prefix=${placeholder "out"}"];
  enableParallelBuilding = true;
}
