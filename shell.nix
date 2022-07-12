{ pkgs ? import <nixpkgs> {} }:
let
  home-manager = import (
    builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz"
  ) { inherit pkgs; };
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gnumake
    git-crypt
    home-manager.home-manager
  ];
}
