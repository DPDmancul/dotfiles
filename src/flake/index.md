# Flake

Managing the config with flakes allows to pin source versions.

```nix flake.nix
{
  description = "DPD- NixOs config";

  inputs = {
    <<<flake-inputs>>>
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        args = {
          inherit inputs;
          dotfiles = "<<<pwd>>>";
        };
      in
      rec {
        <<<flake-outputs>>>
      }
    );
}
```

## Inputs

### Channels

```nix "flake-inputs" +=
# stable.url = "github:nixos/nixpkgs/nixos-22.11";
unstable.url = "github:nixos/nixpkgs/nixos-unstable";
master.url = "github:nixos/nixpkgs/master";
fallback.url = "github:nixos/nixpkgs/nixos-unstable-small"; # TODO: stable
nixpkgs.follows = "unstable"; # TODO: stable
```

### Nix User Repository

```nix "flake-inputs" +=
nur.url = "github:nix-community/NUR";
```

### Utilities

Home manager, flake utils, hardware config and color schemes

```nix "flake-inputs" +=
home-manager = {
  url = "github:nix-community/home-manager";
  inputs.nixpkgs.follows = "nixpkgs";
};
flake-utils.url = "github:numtide/flake-utils";
hardware.url = "github:nixos/nixos-hardware";
nix-colors.url = "github:misterio77/nix-colors";
```

## Outputs

### Packages

Add overlays to pkgs (e.g. NUR).

Moreover generate an unfree overlay which is identical to nixpkgs, but allows unfree packages. In this way it is easier to track unfree software.  
**Warning**: such packages are not FOSS and so it is not guaranteed they don't harm the system.

```nix "flake-outputs" +=
legacyPackages = let
  overlays = [
    inputs.nur.overlay
    (self: super: {
      unstable = inputs.unstable.legacyPackages.${system};
      master = inputs.master.legacyPackages.${system};
      fallback = import inputs.fallback {
        inherit system;
        config = {
          allowBroken = true;
          allowInsecure = true;
        };
      };
    })
    # <<<pkgs-overlays>>>
  ];
in
import nixpkgs {
  inherit system;
  overlays = overlays ++ [
    (self: super: {
      unfree = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };
    })
  ];
  config.allowUnfreePredicate = pkg:
    builtins.elem (nixpkgs.lib.getName pkg) [
      <<<unfree-extra>>>
    ];
};
```

### System config

```nix "flake-outputs" +=
packages.nixosConfigurations = {
  nixos = nixpkgs.lib.nixosSystem {
    inherit system;
    pkgs = legacyPackages;
    modules = [ ./configuration.nix ];
    specialArgs = args;
  };
};
```

### Home-manager config

```nix "flake-outputs" +=
packages.homeConfigurations = {
  "dpd-@nixos" = home-manager.lib.homeManagerConfiguration {
    pkgs = legacyPackages;
    modules = [ ./home.nix ];
    extraSpecialArgs = args;
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

