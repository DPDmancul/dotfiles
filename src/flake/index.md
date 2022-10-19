# Flake

Managing the config with flakes allows to pin source versions.

```nix flake.nix
{
  description = "DPD- NixOs config";

  inputs = {
    <<<flake-inputs>>>
  };

  outputs = args@{ self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      <<<flake-outputs>>>
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
home-manager = {
  url = "github:nix-community/home-manager";
  inputs.nixpkgs.follows = "nixpkgs";
};
flake-utils.url = "github:numtide/flake-utils";
```

## Outputs

### System config

```nix "flake-outputs" +=
packages.nixosConfigurations = {
  nixos = nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [ ./configuration.nix ];
    specialArgs = {
      inherit args;
    };
  };
};
```

### Home-manager config

```nix "flake-outputs" +=
packages.homeConfigurations = {
  "dpd-@nixos" = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [ ./home.nix ];
    extraSpecialArgs = {
      inherit args;
      dotfiles = "<<<pwd>>>";
    };
  };
};
```

## Home manager

Use home manager from its flake

```nix "flake-outputs" +=
apps.home-manager = {
  type = "app";
  program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
};
```

