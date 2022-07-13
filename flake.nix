{
  description = "DPD- NixOs config";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = args@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: {
      packages.nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./configuration.nix) ];
          specialArgs = { inherit args; };
        };
      };
    });
}

