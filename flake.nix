{
  description = "DPD- NixOs config";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = args@{ self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      args.pkgs = pkgs;
      args.dotfiles = "/home/dpd-/.dotfiles";
    in {
      packages.nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./configuration.nix) ];
          specialArgs = args;
        };
      };
      packages.homeConfigurations = {
        "dpd-@nixos" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
          extraSpecialArgs = args;
        };
      };
      apps.home-manager = {
        type = "app";
        program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
      };
    });
}

