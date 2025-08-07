# RISC Zero toolchain versions and their hashes
# TODO: Automate the creation of this with an idempotent script
{
  "1.88.0" = {
    date = "2025-08-07";
    src = {
      x86_64-linux = {
        url = "https://github.com/risc0/rust/releases/download/r0.1.88.0/rust-toolchain-x86_64-unknown-linux-gnu.tar.gz";
        hash = "sha256-IiZReXuljwuv2VkZGkjSOzWzJm2eCC/En7TYRzMGT84=";
      };
      aarch64-darwin = {
        url = "https://github.com/risc0/rust/releases/download/r0.1.88.0/rust-toolchain-aarch64-apple-darwin.tar.gz";
        hash = "sha256-89aj2+CVNvcWbP9T/V3tYyoLVAm3z6pSAkI/bDMjwEw=";
      };
    };
  };
}
