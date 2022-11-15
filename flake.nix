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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        args = {
          inherit inputs;
          dotfiles = "/home/dpd-/.dotfiles";
        };
      in
      rec {
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
              "brscan4"
              "brscan4-etc-files"
              "brother-udev-rule-type1"
            ];
        };
        packages.nixosConfigurations = {
          nixos = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = legacyPackages;
            modules = [ ./configuration.nix ];
            specialArgs = args;
          };
        };
        packages.homeConfigurations = {
          "dpd-@nixos" = home-manager.lib.homeManagerConfiguration {
            pkgs = legacyPackages;
            modules = [ ./home.nix ];
            extraSpecialArgs = args;
          };
        };
        apps.home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      }
    );
}
