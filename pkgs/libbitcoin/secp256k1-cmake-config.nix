{
  stdenv,
  lib,
  runCommand,
  secp256k1,
}:
runCommand "libsecp256k1-cmake-config-${secp256k1.version}"
  {
    meta = {
      description = "CMake package config shim for nixpkgs secp256k1";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
    };
  }
  ''
    configDir="$out/lib/cmake/libsecp256k1"
    mkdir -p "$configDir"

    cat > "$configDir/libsecp256k1-config.cmake" <<'EOF'
    if(NOT TARGET libsecp256k1::secp256k1)
      add_library(libsecp256k1::secp256k1 UNKNOWN IMPORTED)
      set_target_properties(libsecp256k1::secp256k1 PROPERTIES
        IMPORTED_LOCATION "${secp256k1}/lib/libsecp256k1${stdenv.hostPlatform.extensions.sharedLibrary}"
        INTERFACE_INCLUDE_DIRECTORIES "${secp256k1}/include"
      )
    endif()

    set(libsecp256k1_VERSION "${secp256k1.version}")
    set(libsecp256k1_FOUND TRUE)
    EOF

    cat > "$configDir/libsecp256k1-config-version.cmake" <<'EOF'
    set(PACKAGE_VERSION "${secp256k1.version}")

    if(PACKAGE_FIND_VERSION VERSION_EQUAL PACKAGE_VERSION)
      set(PACKAGE_VERSION_EXACT TRUE)
      set(PACKAGE_VERSION_COMPATIBLE TRUE)
    elseif(PACKAGE_FIND_VERSION VERSION_LESS PACKAGE_VERSION)
      set(PACKAGE_VERSION_COMPATIBLE TRUE)
    else()
      set(PACKAGE_VERSION_COMPATIBLE FALSE)
    endif()
    EOF
  ''
