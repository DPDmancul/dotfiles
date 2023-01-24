{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    nodePackages.npm
  ];

  # You must manually install `npm i -g eslint`
  # and run `npx eslint --init` in all projects
  nvimLSP.eslint = rec { # JS (EcmaScript) and TS
    package = pkgs.nodePackages.vscode-langservers-extracted;
    config = {
      cmd = ["${package}/bin/vscode-eslint-language-server" "--stdio"];
    };
  };
}
