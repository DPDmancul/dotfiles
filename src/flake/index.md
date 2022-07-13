# Flake

Managing the config with flakes allows to pin source versions.

```nix flake.nix
{
  description = "DPD- NixOs config";

  inputs = {
    <<<flake-inputs>>>
  };

  outputs = args@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: {
      packages.nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./configuration.nix) ];
          specialArgs = { inherit args; };
        };
      };
    });
}

```

## Inputs

### Channels

```nix "flake-inputs" +=
unstable.url = "github:nixos/nixpkgs/nixos-unstable";
nixpkgs.follows = "unstable";
```

### Utilities

```nix "flake-inputs" +=
flake-utils.url = "github:numtide/flake-utils";
```

