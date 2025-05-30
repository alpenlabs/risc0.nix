# RISC Zero toolchain versions and their hashes
# TODO: Automate the creation of this with an idempotent script
{
  "1.85.0" = {
    date = "2025-03-13";
    src = {
      x86_64-linux = {
        url = "https://github.com/risc0/rust/releases/download/r0.1.85.0/rust-toolchain-x86_64-unknown-linux-gnu.tar.gz";
        hash = "sha256-B2dOSbN2FbeNL7J2AcUJCSM8IfHxo6koFlgglySnrMs=";
      };
      aarch64-linux = {
        url = "https://github.com/risc0/rust/releases/download/r0.1.85.0/rust-toolchain-aarch64-unknown-linux-gnu.tar.gz";
        hash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
      };
      x86_64-darwin = {
        url = "https://github.com/risc0/rust/releases/download/r0.1.85.0/rust-toolchain-x86_64-apple-darwin.tar.gz";
        hash = "sha256-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=";
      };
      aarch64-darwin = {
        url = "https://github.com/risc0/rust/releases/download/r0.1.85.0/rust-toolchain-aarch64-apple-darwin.tar.gz";
        hash = "sha256-DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD=";
      };
    };
  };
}
