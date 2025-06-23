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
    rev = "71aaf453bbc8785e7aac792da0af113ef51f8e5a";
    sha256 = "sha256-MWYRtOGyoX2EnMWSz7t6nDqagZdIQ/raiYPKwD3UlIw";
  };

  # this is a straight copy from the libbitcoin-system flake
  # id prefer if we can pass this along but would will leave
  # as a follow-up for now
  nativeBuildInputs = [autoreconfHook pkg-config];
  buildInputs = [boost186 secp256k1 libbitcoin-system];
  patches = [ ./fix-clang-initializer.diff ];
  configureFlags = [
    "--with-boost-libdir=${boost186.out}/lib"
  ];

  makeFlags = ["prefix=${placeholder "out"}"];
  enableParallelBuilding = true;
}
