# RISC0 Nix Package Collection

This repository provides Nix packages for RISC0 tools,
including the [`risc0/rust` toolchain](https://github.com/risc0/rust).

## Packages

- **`risc0-toolchain`** - RISC Zero's custom Rust toolchain with zkVM target support
- **`rust-bin-risc0-latest`** - Latest RISC Zero Rust toolchain (currently 1.88.0)

Available platforms (based on RISC0 r0.1.88.0 release):

- `x86_64-linux`
- `aarch64-darwin`

## Usage

### With Flakes

Add this repository as an input to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    risc0-nix = {
      url = "github:alpenlabs/risc0.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, risc0-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ risc0-nix.overlays.default ];
        };
      in {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            risc0-toolchain
          ];
        };

        # Direct package access
        packages = {
          inherit (pkgs) risc0-toolchain;
        };
      });
}
```

#### Quick Development Shell

For a quick development environment, you can use:

```bash
nix develop github:alpenlabs/risc0.nix
```

Or create a temporary shell with the tools:

```bash
nix shell github:alpenlabs/risc0.nix#rust-bin-risc0-latest
nix shell github:alpenlabs/risc0.nix#risc0-toolchain
```

### Without Flakes (shell.nix)

Create a `shell.nix` file in your project:

```nix
let
  # Pin nixpkgs to a specific version for reproducibility
  pkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz";
  }) {
    overlays = [
      # Import the RISC0 overlay
      (import (fetchTarball {
        url = "https://github.com/alpenlabs/risc0.nix/archive/main.tar.gz";
      })).overlays.default
    ];
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    risc0-toolchain
  ];

  shellHook = ''
    echo "RISC0 development environment loaded!"
    echo "Available tools:"
    echo "  - rustc: $(rustc --version 2>/dev/null || echo 'not found')"
    echo "  - cargo: $(cargo --version 2>/dev/null || echo 'not found')"
  '';
}
```

Then enter the shell with:

```bash
nix-shell
```

### Using Specific Versions

To use a specific version of this overlay, you can pin it to a commit:

#### With Flakes

```nix
{
  inputs = {
    risc0-nix = {
      url = "github:alpenlabs/risc0.nix/COMMIT_HASH";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

#### Without Flakes

```nix
let
  risc0-nix = fetchTarball {
    url = "https://github.com/alpenlabs/risc0.nix/archive/COMMIT_HASH.tar.gz";
    sha256 = "0000000000000000000000000000000000000000000000000000"; # Use real hash
  };
  pkgs = import <nixpkgs> {
    overlays = [ (import risc0-nix).overlays.default ];
  };
in
# ... rest of your configuration
```

## Building Locally

To build the packages locally:

```bash
# Clone this repository
git clone https://github.com/alpenlabs/risc0.nix.git
cd risc0.nix

# Build individual packages
nix build .#rust-bin-risc0-latest
nix build .#risc0-toolchain

# Enter development shell
nix develop
```

## Contributing

1. Fork the repository
2. Make your changes
3. Test builds on your platform: `nix build .#rust-bin-risc0-latest .#risc0-toolchain`
4. Submit a pull request

The CI will test builds on supported platforms.

## License

This repository is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
