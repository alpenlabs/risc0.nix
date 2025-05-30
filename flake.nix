{
  description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    let
      overlays = [ inputs.self.overlays.default ];
      perSystemPkgs =
        f:
        inputs.nixpkgs.lib.genAttrs (import inputs.systems) (
          system: f (import inputs.nixpkgs { inherit overlays system; })
        );
    in
    {
      overlays = {
        default = import ./overlay.nix;
      };

      packages = perSystemPkgs (pkgs: {
        rust-bin-risc0-latest = pkgs.rust-bin.risc0.latest;
        default = inputs.self.packages.${pkgs.system}.rust-bin-risc0-latest;
      });

      devShells = perSystemPkgs (pkgs: {
        risc0-user-latest = pkgs.callPackage ./shell.nix { };
        default = inputs.self.devShells.${pkgs.system}.risc0-user-latest;
      });

      formatter = perSystemPkgs (pkgs: pkgs.nixfmt-tree);
    };
}
