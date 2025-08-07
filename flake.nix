{
  description = "RISC Zero Nix Package Collection";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    risc0-src = {
      url = "github:risc0/rust";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
      risc0-src,
    }:
    {
      overlays = {
        default = import ./overlay.nix { inherit risc0-src; };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            rust-overlay.overlays.default
            self.overlays.default
          ];
        };
      in
      {
        packages = {
          rust-bin-risc0-latest = pkgs.rust-bin.risc0.latest;
          risc0-toolchain = pkgs.rust-bin.risc0.latest;
          default = self.packages.${system}.rust-bin-risc0-latest;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rust-bin-risc0-latest
          ];
        };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
