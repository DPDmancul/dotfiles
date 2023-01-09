{ pkgs ? import <nixpkgs> { } }:
let
  flakeShellPath = ./flake/shell.nix;
  flakeShell = import flakeShellPath { inherit pkgs; };
  lock = builtins.fromJSON (builtins.readFile ./flake/flake.lock);
  nur = import
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/NUR/archive/${lock.nodes.nur.locked.rev}.tar.gz";
      sha256 = lock.nodes.nur.locked.narHash;
    })
    {
      inherit pkgs;
    };
  nativeBuildInputs = with pkgs; [
    gnused
    jq
    mdbook
    nur.repos.hutzdog.lmt
  ];
in
if builtins.pathExists flakeShellPath then
  flakeShell.overrideAttrs
    (oldAttrs: {
      nativeBuildInputs = oldAttrs.nativeBuildInputs ++ nativeBuildInputs;
    })
else
  pkgs.mkShell {
    inherit nativeBuildInputs;
  }

