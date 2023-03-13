# Flake

Managing the config with flakes allows to pin source versions.

```nix flake.nix
{
  description = "DPD- NixOs config";

  inputs = {
    <<<flake-inputs>>>
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, sops-nix, ... }:
    let
      machines = [
        {
          host = "PereBook";
          system = "x86_64-linux";
          users = [ "dpd-" ];
        }
        {
          host = "PereWork";
          system = "x86_64-linux";
          users = [ "dpd-" ];
        }
      ];
      args = {
        inherit inputs;
        dotfiles = "<<<pwd>>>";
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
stable.url = github:nixos/nixpkgs/nixos-22.11;
unstable.url = github:nixos/nixpkgs/nixos-unstable;
master.url = github:nixos/nixpkgs/master;
fallback.url = github:nixos/nixpkgs/nixos-22.11-small;
nixpkgs.follows = "stable";
```

### Nix User Repository

```nix "flake-inputs" +=
nur.url = github:nix-community/NUR;
```

### Utilities

```nix "flake-inputs" +=
home-manager = {
  url = github:nix-community/home-manager/release-22.11;
  inputs.nixpkgs.follows = "nixpkgs";
};
hardware.url = github:nixos/nixos-hardware;
sops-nix.url = github:Mic92/sops-nix;
nix2lua.url = git+https://git.pleshevski.ru/mynix/nix2lua;
```

## Outputs

### Packages

Add overlays to pkgs (e.g. NUR and custom packages).

Moreover generate an unfree overlay which is identical to nixpkgs, but allows unfree packages. In this way it is easier to track unfree software.  
**Warning**: such packages are not FOSS and so it is not guaranteed they don't harm the system.

```nix "flake-outputs" +=
legacyPackages = forAllSystems (system:
  let
    overlays = [
      # NUR
      inputs.nur.overlay
      # unstable, master and fallaback channels
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
      # Custom packages
      (self: super: import ./pkgs { pkgs = self; lib = super.lib; })
    ] ++ import ./overlays;
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
      rec {
        inherit (machine) system;
        pkgs = legacyPackages.${machine.system};
        modules = [
          sops-nix.nixosModules.sops
          { networking.hostName = machine.host; }
          ./${machine.host}/system
        ];
        specialArgs = args // {
          inherit (machine) users;
          lib = pkgs.lib.extend (self: super: import ./lib.nix { lib = self; });
        };
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
        rec {
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
          extraSpecialArgs = args // {
            inherit user;
            lib = pkgs.lib.extend (self: super:
              home-manager.lib //
                import ./lib.nix { lib = self; }
            );
          };
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

