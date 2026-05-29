{
  common,
  libbitcoin-system,
}:
common.mkLibbitcoin {
  pname = "libbitcoin-database";
  repo = "libbitcoin-database";
  rev = "cbc06478121006c570f3d9c0ddb69b3adc3ac20b";
  hash = "0f3my27ly7x0bmf053f6fbh0wqz8yh5g6bs89lp9hkyz3yjig809";

  buildInputs = [libbitcoin-system];

  meta.description = "Memory-mapped blockchain database library for libbitcoin";
}
