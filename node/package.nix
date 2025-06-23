{
  stdenv,
  fetchFromGitHub,
  libbitcoin-system,
  libbitcoin-database,
  libbitcoin-network,
  autoreconfHook,
  pkg-config,
  boost186,
  secp256k1,
}:
stdenv.mkDerivation {
  name = "libbitcoin-node";
  version = "master";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = "libbitcoin-node";
    rev = "2b793a28701997d60674c5f158596edb90b15da5";
    sha256 = "sha256-BLRtjzcWql5saiK6KinxKTFcbHzgKOHutrNtFJ/rUqg";
  };

  # this is a straight copy from the libbitcoin-system flake
  # id prefer if we can pass this along but would will leave
  # as a follow-up for now
  nativeBuildInputs = [autoreconfHook pkg-config];
  buildInputs = [boost186 secp256k1 libbitcoin-system libbitcoin-database libbitcoin-network];
  configureFlags = [
    "--with-boost-libdir=${boost186.out}/lib"
  ];

  makeFlags = ["prefix=${placeholder "out"}"];
  enableParallelBuilding = true;
}
