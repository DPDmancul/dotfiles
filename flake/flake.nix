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
    hardware.url = github:nixos/nixos-hardware;
    sops-nix.url = github:Mic92/sops-nix;
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
    in
    rec {
      legacyPackages = forAllSystems (system:
        let
          overlays = config: [
            # unstable, master and fallaback channels
            (self: super: {
              unstable = import inputs.unstable { inherit system config; };
              "25.05" = import inputs."25.05" { inherit system config; };
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
      nixosConfigurations = builtins.listToAttrs (map
        (machine: {
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
            value = inputs.home-manager.lib.homeManagerConfiguration
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
                    inputs.home-manager.lib //
                      import ./lib.nix { lib = self; }
                  );
                };
              };
          })
          machine.users)
        machines);
      apps.home-manager = forAllSystems (system: {
        type = "app";
        program = "${inputs.home-manager.packages.${system}.home-manager}/bin/home-manager";
      });
    };
}
