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
  name = "libbitcoin-database";
  version = "master";

  src = fetchFromGitHub {
    owner = "libbitcoin";
    repo = "libbitcoin-database";
    rev = "master";
    sha256 = "sha256-ZwNo5LePgP3wwqaWbB5FRlwtsQYNborkcOV+Yknmtd4";
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
