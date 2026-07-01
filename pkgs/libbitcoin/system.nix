{
  common,
  lib,
  enableXcpu ? false,
  systemPatches ? [],
}:
common.mkLibbitcoin {
  pname = "libbitcoin-system";
  repo = "libbitcoin-system";
  rev = "b4821a37afc4b79c1c4b92d9d4a47bae84c3c881";
  hash = "0h88sx349r915lpbfcw3w8x604v11yxfx41y6ri76cdhfjgfx6wz";
  patches = systemPatches;
  patchRoot =
    if systemPatches != []
    then "../.."
    else ".";
  cmakeFlags =
    ["-Dwith-examples=OFF"]
    ++ lib.optionals enableXcpu [
      "-Denable-avx2=ON"
      "-Denable-shani=ON"
    ];

  meta.description = "Foundational C++ library for the libbitcoin toolkit";
}
