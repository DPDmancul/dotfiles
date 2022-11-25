# Flake

Managing the config with flakes allows to pin source versions.

```nix flake.nix
{
  description = "DPD- NixOs config";

  inputs = {
    <<<flake-inputs>>>
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, ... }:
    let
      machines = [
        {
          host = "PereBook";
          system = "x86_64-linux";
          users = [ "dpd-" ];
        }
      ];
      args = {
        inherit inputs;
        dotfiles = "<<<pwd>>>";
        secrets = import ./secrets.nix;
        assets = ./assets;
        modules = ./modules;
      };
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.doubles.all;
    in
    rec {
      <<<flake-outputs>>>
    };
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
  url = "github:nix-community/home-manager"; # TODO: stable
  inputs.nixpkgs.follows = "nixpkgs";
};
hardware.url = "github:nixos/nixos-hardware";
stylix-colors.url = "github:danth/stylix";
```

## Outputs

### Packages

Add overlays to pkgs (e.g. NUR).

Moreover generate an unfree overlay which is identical to nixpkgs, but allows unfree packages. In this way it is easier to track unfree software.  
**Warning**: such packages are not FOSS and so it is not guaranteed they don't harm the system.

```nix "flake-outputs" +=
legacyPackages = forAllSystems (system:
  let
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
  }
);
```

### System config

```nix "flake-outputs" +=
nixosConfigurations = builtins.listToAttrs (map
  (machine: {
    name = machine.host;
    value = nixpkgs.lib.nixosSystem
      {
        inherit (machine) system;
        pkgs = legacyPackages.${machine.system};
        modules = [
          { networking.hostName = machine.host; }
          ./modules/system
          ./${machine.host}/system/hardware-configuration.nix
          ./${machine.host}/system
        ];
        specialArgs = args // { inherit (machine) users; };
      };
  })
  machines);
```

### Home-manager config

```nix "flake-outputs" +=
homeConfigurations = builtins.listToAttrs (builtins.concatMap
  (machine: map
    (user: {
      name = "${user}@${machine.host}";
      value = home-manager.lib.homeManagerConfiguration
        {
          pkgs = legacyPackages.${machine.system};
          modules =
            let
              cfg-path = ./${machine.host}/${user};
            in
            [
              (
                if builtins.pathExists cfg-path then
                  cfg-path
                else ./${machine.host}/home
              )
            ];
          extraSpecialArgs = args // { inherit user; };
        };
    })
    machine.users)
  machines);
```

## Home manager

Use home manager from its flake

```nix "flake-outputs" +=
apps.home-manager = forAllSystems (system: {
  type = "app";
  program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
});
```

