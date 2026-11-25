{
  description = "DPD- NixOs config";

  inputs = {
    stable.url = github:nixos/nixpkgs/nixos-26.05;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nixpkgs.follows = "stable";
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
    feh-random-background = {
      url = github:KoviRobi/feh-random-background/80bc3616bb8fc87225d1447431555230a4bf3b12;
      flake = false;
    };
    wallpapers = {
      url = gitlab:DPDmancul/dotfiles-wallpapers;
      flake = false;
    };
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
        dotfiles = "/home/dpd-/.dotfiles";
        assets = ./assets;
        modules = ./modules;
      };
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.doubles.all;
      lib = inputs.nixpkgs.lib;
    in
    rec {
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
              "teamviewer"
              "brscan4"
              "brscan4-etc-files"
              "brother-udev-rule-type1"
            ];
        }
      );
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
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = args // {
                  lib = pkgs.lib.extend (self: super:
                    inputs.home-manager.lib //
                      import ./lib.nix { lib = self; }
                  );
                };
                home-manager.backupFileExtension = "bkp";
                home-manager.overwriteBackup = true;
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
              }
            ];
            specialArgs = args // {
              inherit (machine) users;
              lib = pkgs.lib.extend (self: super: import ./lib.nix { lib = self; });
            };
          };
      });
    };
}
