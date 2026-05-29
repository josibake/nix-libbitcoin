{
  common,
  libbitcoin-system,
}:
common.mkLibbitcoin {
  pname = "libbitcoin-network";
  repo = "libbitcoin-network";
  rev = "0450a00c55709ebe369eb5751dc3b3bf0b65d924";
  hash = "0hprpx5pim1c3sf35wp2c8p6z8hywmaqkskq1m0n3sw2s69zzfr2";

  propagatedBuildInputs = [libbitcoin-system];

  meta.description = "Bitcoin P2P networking library for libbitcoin";
}
