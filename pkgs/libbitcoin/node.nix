{
  common,
  libbitcoin-database,
  libbitcoin-network,
}:
common.mkLibbitcoin {
  pname = "libbitcoin-node";
  repo = "libbitcoin-node";
  rev = "6a765df6fa8ddbc582371956681f3efe30bcb2a8";
  hash = "0zcl1s4w5dpk9mlha274d5x88f85gby7l0ys0dmqg25q1hwj924q";

  propagatedBuildInputs = [
    libbitcoin-database
    libbitcoin-network
  ];
  cmakeFlags = [ "-Dwith-console=ON" ];

  meta.description = "Bitcoin full node library and console for libbitcoin";
  meta.mainProgram = "bn";
}
