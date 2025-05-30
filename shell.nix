# A dev environment for devs *using* risc0 to build and run host+guest pairs.
{
  cargo-risczero,
  gcc,
  mkShell,
  rust-bin,
}:
mkShell {
  buildInputs = [
    cargo-risczero
    gcc
    rust-bin.risc0.latest
  ];
}
