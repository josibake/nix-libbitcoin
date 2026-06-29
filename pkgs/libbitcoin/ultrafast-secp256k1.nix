{
  stdenv,
  ccacheStdenv,
  lib,
  fetchFromGitHub,
  cmake,
  cudaPackages ? null,
  withCuda ? false,
  cudaArchitectures ? null,
  useCcache ? false,
  ccacheDir ? "/var/cache/ccache",
  ccacheMaxSize ? "50G",
}:
let
  version = "dev-caba608d";
  buildStdenv =
    if useCcache then
      ccacheStdenv.override {
        extraConfig = ''
          export CCACHE_COMPRESS=1
          export CCACHE_DIR=${ccacheDir}
          export CCACHE_MAXSIZE=${ccacheMaxSize}
          export CCACHE_UMASK=007
        '';
      }
    else
      stdenv;
in
buildStdenv.mkDerivation {
  pname = "ultrafast-secp256k1";
  inherit version;

  src = fetchFromGitHub {
    owner = "shrec";
    repo = "UltrafastSecp256k1";
    rev = "caba608d7ee0226ac8060fe057df8fbbdad3838e";
    hash = "sha256-eaOAndl9CC0dKbO30OZsybK6LzvgP5euEbGPde8+EPQ=";
  };

  patches = [
    ./patches/ultrafast-cuda-field-inv-launch-bounds.patch
    ./patches/ultrafast-libbitcoin-streaming-gpu.patch
    ./patches/ultrafast-libbitcoin-bridge-status-propagation.patch
    ./patches/ultrafast-cuda-column-offsets-64bit.patch
    ./patches/ultrafast-cuda-columnar-schnorr-fast-path.patch
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals (withCuda && cudaPackages != null) [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = lib.optionals (withCuda && cudaPackages != null) [
    cudaPackages.cuda_cudart
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DSECP256K1_BUILD_LIBBITCOIN=OFF"
    "-DSECP256K1_BUILD_LIBBITCOIN_BRIDGE=ON"
    "-DSECP256K1_BUILD_CPU=ON"
    "-DSECP256K1_BUILD_CUDA=${if withCuda then "ON" else "OFF"}"
    "-DSECP256K1_BUILD_ROCM=OFF"
    "-DSECP256K1_BUILD_OPENCL=OFF"
    "-DSECP256K1_BUILD_METAL=OFF"
    "-DSECP256K1_BUILD_TESTS=OFF"
    "-DSECP256K1_BUILD_BENCH=OFF"
    "-DSECP256K1_BUILD_EXAMPLES=OFF"
    "-DSECP256K1_BUILD_JAVA=OFF"
    "-DSECP256K1_BUILD_CABI=ON"
    "-DSECP256K1_INSTALL_CABI=ON"
    "-DUFSECP_LBTC_BUILD_TESTS=OFF"
    "-DUFSECP_LBTC_BUILD_EXAMPLE=OFF"
    "-DUFSECP_LBTC_BUILD_BENCH=OFF"
    "-DSECP256K1_INSTALL=OFF"
    "-DSECP256K1_INSTALL_PKGCONFIG=OFF"
  ]
  ++ lib.optionals (withCuda && cudaArchitectures != null) [
    "-DCMAKE_CUDA_ARCHITECTURES=${cudaArchitectures}"
  ];

  buildPhase = ''
    runHook preBuild
    cmake --build . --target ufsecp_static --parallel $NIX_BUILD_CORES
    cmake --build . --target ufsecp_shared --parallel $NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/include/ufsecp" "$out/lib" "$out/lib/cmake/secp256k1-fast"
    chmod -R u+w "$out/include/ufsecp" "$out/lib" 2>/dev/null || true

    if [ -f compat/libbitcoin_bridge/include/ufsecp_libbitcoin.h ]; then
      cp compat/libbitcoin_bridge/include/ufsecp_libbitcoin.h \
        "$out/include/ufsecp_libbitcoin.h"
      cp compat/libbitcoin_bridge/include/ufsecp_libbitcoin.h \
        "$out/include/ufsecp/ufsecp_libbitcoin.h"
    else
      cp ../compat/libbitcoin_bridge/include/ufsecp_libbitcoin.h \
        "$out/include/ufsecp_libbitcoin.h"
      cp ../compat/libbitcoin_bridge/include/ufsecp_libbitcoin.h \
        "$out/include/ufsecp/ufsecp_libbitcoin.h"
    fi

    if [ -d ../compat/libbitcoin_direct/include/ufsecp ]; then
      cp -f ../compat/libbitcoin_direct/include/ufsecp/*.hpp "$out/include/ufsecp/"
    elif [ -d compat/libbitcoin_direct/include/ufsecp ]; then
      cp -f compat/libbitcoin_direct/include/ufsecp/*.hpp "$out/include/ufsecp/"
    fi

    if [ -d ../include/ufsecp ]; then
      cp -f ../include/ufsecp/*.h "$out/include/ufsecp/"
    else
      cp -f include/ufsecp/*.h "$out/include/ufsecp/"
    fi
    cp -f include/ufsecp/ufsecp_version.h "$out/include/ufsecp/"

    if [ -f include/ufsecp/libufsecp.a ]; then
      cp include/ufsecp/libufsecp.a "$out/lib/libufsecp.a"
    elif [ -f include/ufsecp/libufsecp_s.a ]; then
      cp include/ufsecp/libufsecp_s.a "$out/lib/libufsecp.a"
    fi

    find include/ufsecp -maxdepth 1 -name 'libufsecp.so*' \
      -exec cp -P {} "$out/lib/" \;

    cat > "$out/lib/cmake/secp256k1-fast/secp256k1-fast-config.cmake" <<EOF
    if (NOT TARGET secp256k1::fastsecp256k1)
      add_library(secp256k1::fastsecp256k1 SHARED IMPORTED)
      set_target_properties(secp256k1::fastsecp256k1 PROPERTIES
        IMPORTED_LOCATION "$out/lib/libufsecp.so"
        INTERFACE_INCLUDE_DIRECTORIES "$out/include"
      )
    endif()

    set(secp256k1-fast_FOUND TRUE)
    EOF

    cat > "$out/lib/cmake/secp256k1-fast/secp256k1-fast-config-version.cmake" <<EOF
    set(PACKAGE_VERSION "4.4.0.0")
    set(PACKAGE_VERSION_COMPATIBLE TRUE)
    set(PACKAGE_VERSION_EXACT FALSE)
    EOF
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/shrec/UltrafastSecp256k1";
    description = "Ultrafast secp256k1 library with libbitcoin bridge";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
