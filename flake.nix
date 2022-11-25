{
  description = "DPD- NixOs config";

  inputs = {
    # stable.url = "github:nixos/nixpkgs/nixos-22.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
    fallback.url = "github:nixos/nixpkgs/nixos-unstable-small"; # TODO: stable
    nixpkgs.follows = "unstable"; # TODO: stable
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager"; # TODO: stable
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    stylix-colors.url = "github:danth/stylix";
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
        dotfiles = "/home/dpd-/.dotfiles";
        secrets = import ./secrets.nix;
        assets = ./assets;
        modules = ./modules;
      };
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.doubles.all;
    in
    rec {
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
      apps.home-manager = forAllSystems (system: {
        type = "app";
        program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
      });
    };
}
