{ pkgs ? import <nixpkgs> { } }:
let
  flake-shell = import ./flake/shell.nix { inherit pkgs; };
  lock = builtins.fromJSON (builtins.readFile ./flake/flake.lock);
  nur = import
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/${lock.nodes.nur.locked.rev}.tar.gz";
      sha256 = lock.nodes.nur.locked.narHash;
    })
    {
      inherit pkgs;
    };
in
flake-shell.overrideAttrs (oldAttrs: {
  nativeBuildInputs = with pkgs; oldAttrs.nativeBuildInputs ++ [
    gnused
    jq
    mdbook
    nur.repos.hutzdog.lmt
  ];
})

