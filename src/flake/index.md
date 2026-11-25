# Flake

Managing the config with flakes allows to pin source versions.

```nix flake.nix
{
  description = "DPD- NixOs config";

  inputs = {
    <<<flake-inputs>>>
  };

  outputs = inputs @ { self, nixpkgs, ... }:
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
      lib = inputs.nixpkgs.lib;
    in
    rec {
      <<<flake-outputs>>>
    };
}
```

## Inputs

### Channels

```nix "flake-inputs" +=
stable.url = github:nixos/nixpkgs/nixos-26.05;
unstable.url = github:nixos/nixpkgs/nixos-unstable;
nixpkgs.follows = "stable";
```

### Utilities

```nix "flake-inputs" +=
home-manager = {
  url = github:nix-community/home-manager/release-26.05;
  inputs.nixpkgs.follows = "nixpkgs";
};
disko = {
  url = "github:nix-community/disko/latest";
  inputs.nixpkgs.follows = "nixpkgs";
};
hardware = {
  url = github:nixos/nixos-hardware;
  inputs.nixpkgs.follows = "nixpkgs";
};
sops-nix = {
  url = github:Mic92/sops-nix;
  inputs.nixpkgs.follows = "nixpkgs";
};
```

## Outputs

### Packages

Add overlays to pkgs (e.g. NUR and custom packages).

Moreover generate an unfree overlay which is identical to nixpkgs, but allows unfree packages. In this way it is easier to track unfree software.  
**Warning**: such packages are not FOSS and so it is not guaranteed they don't harm the system.

```nix "flake-outputs" +=
legacyPackages = forAllSystems (system:
  let
    overlays = config: [
      # unstable, master and fallaback channels
      (self: super: {
        unstable = import inputs.unstable { inherit system config; };
      })
      # Custom packages
      (self: super: import ./pkgs { pkgs = self; lib = super.lib; })
    ] ++ import ./overlays;
  in
  import nixpkgs {
    inherit system;
    overlays = (overlays {}) ++ [
      (self: super: {
        unfree = import nixpkgs {
          inherit system;
          overlays = (overlays { allowUnfree = true; });
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
nixosConfigurations = lib.genAttrs' machines (machine: {
  name = machine.host;
  value = nixpkgs.lib.nixosSystem
    rec {
      inherit (machine) system;
      pkgs = legacyPackages.${machine.system};
      modules = [
        inputs.sops-nix.nixosModules.sops
        inputs.disko.nixosModules.disko
        { networking.hostName = machine.host; }
        ./${machine.host}/system
        inputs.home-manager.nixosModules.home-manager
        {
          <<<flake-outputs-home-manager>>>
        }
      ];
      specialArgs = args // {
        inherit (machine) users;
        lib = pkgs.lib.extend (self: super: import ./lib.nix { lib = self; });
      };
    };
});
```

### Home-manager

```nix "flake-outputs-home-manager" +=
home-manager.useGlobalPkgs = true;
home-manager.useUserPackages = true;
home-manager.extraSpecialArgs = args // {
  lib = pkgs.lib.extend (self: super:
    inputs.home-manager.lib //
      import ./lib.nix { lib = self; }
  );
};
```

#### Backup files

```nix "flake-outputs-home-manager" +=
home-manager.backupFileExtension = "bkp";
home-manager.overwriteBackup = true;
```

#### Config

```nix "flake-outputs-home-manager" +=
home-manager.users = lib.genAttrs machine.users (user:
  let
    cfg-path = ./${machine.host}/${user};
  in {
    _module.args.user = user;
    imports = [
      (if builtins.pathExists cfg-path
        then cfg-path
        else ./${machine.host}/home)
    ];
  }
);
```

