{
  common,
  libbitcoin-node,
}:
common.mkLibbitcoin {
  pname = "libbitcoin-server";
  repo = "libbitcoin-server";
  rev = "1df3db4a653ca56a8785093bc7facee4996796b0";
  hash = "1dqxqrw2m8skb822wb3nrh93l8731xjmf80xycf097pa7nr79gm9";

  buildInputs = [libbitcoin-node];
  cmakeFlags = ["-Dwith-console=ON"];

  meta.description = "High performance Bitcoin full node query server";
  meta.mainProgram = "bs";
}
