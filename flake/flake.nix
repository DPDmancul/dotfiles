{
  description = "DPD- NixOs config";

  inputs = {
    stable.url = github:nixos/nixpkgs/nixos-23.11;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    master.url = github:nixos/nixpkgs/master;
    fallback.url = github:nixos/nixpkgs/nixos-23.11-small;
    nixpkgs.follows = "stable";
    nur.url = github:nix-community/NUR;
    home-manager = {
      url = github:nix-community/home-manager/release-23.11;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = github:nixos/nixos-hardware;
    sops-nix.url = github:Mic92/sops-nix;
    nix2lua.url = git+https://git.pleshevski.ru/mynix/nix2lua;
    feh-random-background = {
      url = github:KoviRobi/feh-random-background;
      flake = false;
    };
    wallpapers = {
      url = gitlab:DPDmancul/dotfiles-wallpapers;
      flake = false;
    };
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
        dotfiles = "/home/dpd-/.dotfiles";
        assets = ./assets;
        modules = ./modules;
      };
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.doubles.all;
    in
    rec {
      legacyPackages = forAllSystems (system:
        let
          overlays = config: [
            # NUR
            inputs.nur.overlay
            # unstable, master and fallaback channels
            (self: super: {
              unstable = import inputs.unstable { inherit system config; };
              master = import inputs.master { inherit system config; };
              fallback = import inputs.fallback {
                inherit system;
                config = config // {
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
              "brscan4"
              "brscan4-etc-files"
              "brother-udev-rule-type1"
              "broadcom-bt-firmware"
              "b43-firmware"
              "xow_dongle-firmware"
              "facetimehd-firmware"
              "facetimehd-calibration"
              "nvidia-x11"
              "nvidia-settings"
              "teamviewer"
            ];
        }
      );
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
      apps.home-manager = forAllSystems (system: {
        type = "app";
        program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
      });
    };
}
