{ pkgs ? import <nixpkgs> { } }:
let
  flakeShellPath = ./flake/shell.nix;
  flakeShell = import flakeShellPath { inherit pkgs; };
  lmt = pkgs.buildGoModule {
      pname = "lmt";
      version = "3-8-2021";

      src = pkgs.fetchFromGitHub {
        owner = "driusan";
        repo = "lmt";
        rev = "a940ba5299babf61ab6dfc72f308ea362cb6e4ec";
        sha256 = "0jpiv9xm8wbi8rdfkkqfhqmjqqfzzhbwwh9m2n52cy4dxbfs8wbh";
      };

      vendorHash = null;

      prePatch = ''
        echo -e "module lmt\n\ngo 1.12" > go.mod
      '';
  };
  nativeBuildInputs = with pkgs; [
    gnused
    jq
    mdbook
    lmt
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

