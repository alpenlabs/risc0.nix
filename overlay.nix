# risc0-overlay.nix
final: prev:
let
  # Import the versions
  versions = import ./versions.nix;

  # Create RISC Zero toolchain
  mkRisc0Toolchain = { version }: prev.callPackage ./pkgs/risc0-toolchain.nix { inherit version; };

  # Create all available toolchains from versions.nix
  risc0Toolchains = prev.lib.mapAttrs (version: _: mkRisc0Toolchain { inherit version; }) versions;

  # Find the latest version using semver comparison
  latestVersion = prev.lib.last (prev.lib.sort prev.lib.versionOlder (prev.lib.attrNames versions));

in
{
  # Extend rust-bin namespace to include RISC Zero toolchains
  rust-bin = (prev.rust-bin or { }) // {
    risc0 = risc0Toolchains // {
      latest = risc0Toolchains.${latestVersion};
    };
  };

  # Create a RISC Zero-specific rustPlatform
  risc0Platform = final.makeRustPlatform {
    rustc = final.rust-bin.risc0.latest;
    cargo = final.rust-bin.risc0.latest;
  };

  # Helper function to build RISC Zero packages
  buildRiscZeroPackage =
    args:
    final.risc0Platform.buildRustPackage (
      args
      // {
        # Ensure we use the RISC Zero target
        # FIXME: likely need to use custom nixpkgs system instead...
        cargoExtraArgs = (args.cargoExtraArgs or "") + " --target riscv32im-risc0-zkvm-elf";
      }
    );
}
