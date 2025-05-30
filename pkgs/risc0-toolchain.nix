{
  autoPatchelfHook,
  fetchurl,
  gccForLibs,
  lib,
  stdenv,
  version, # Must be specified
}:
let
  # The known risczero toolchain versions
  versions = import ../versions.nix;
  versionData = versions.${version} or (throw "RISC Zero Rust version ${version} not available");
  srcData =
    versionData.src.${stdenv.hostPlatform.system}
      or (throw "RISC Zero Rust not available for platform ${stdenv.hostPlatform.system}");
  rustHostPlatform = stdenv.hostPlatform.rust.rustcTarget;
in
stdenv.mkDerivation {
  pname = "risc0-toolchain-bin";
  inherit version;

  src = fetchurl {
    inherit (srcData) url hash;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.isLinux [
    gccForLibs.lib
  ];

  dontStrip = true;

  unpackPhase = ''
    runHook preUnpack
    tar -xzf $src
    runHook postUnpack
  '';

  installPhase = ''
    mkdir -p $out
    mv bin lib $out/
  '';

  # Metadata compatible with rust-overlay expectations
  passthru = {
    inherit version;
    isRisc0Toolchain = true;
    rustcVersion = version;
    rustcCommitHash = "risc0-${version}";
    availableComponents = [
      "rustc"
      "cargo"
      "rust-std"
    ];
    rustTargetPlatform = rustHostPlatform;
  };

  meta = with lib; {
    description = "RISC Zero custom Rust toolchain with zkVM target support";
    homepage = "https://risczero.com";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
